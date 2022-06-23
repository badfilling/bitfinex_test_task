//
//  TradingPairsViewModel.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import Combine
import UIKit

protocol TradingPairsViewModel {
    var input: PassthroughSubject<TradingPairsViewModelInput, Never> { get }
    var output: AnyPublisher<TradingPairsViewModelOutput, Never> { get }
}

enum TradingPairsViewModelInput {
    case viewDidLoad
    case search(text: String)
    case forceRefresh
    case connectionIndicatorTapped
}

enum TradingPairsViewModelOutput {
    case loaded(items: [TradingPairItemModel])
    case updated(items: [TradingPairItemModel])
    case showConnectionIssueIndicator
    case showConnectionIssueAlert
}

class TradingPairsViewModelImpl: TradingPairsViewModel {
    let input: PassthroughSubject<TradingPairsViewModelInput, Never> = .init()
    
    var output: AnyPublisher<TradingPairsViewModelOutput, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private let _output: PassthroughSubject<TradingPairsViewModelOutput, Never> = .init()
    private let forceRefreshSubject: PassthroughSubject<Void, Never> = .init()
    private let dataStore: TradingPairsDataStore
    private let service: TradingPairsService
    private let refreshController: TradingPairsRefreshController
    
    private var bin = Set<AnyCancellable>()
    
    init(
        dataStore: TradingPairsDataStore,
        service: TradingPairsService,
        refreshController: TradingPairsRefreshController
    ) {
        self.dataStore = dataStore
        self.service = service
        self.refreshController = refreshController
        bindInput()
        setupRefreshValues()
    }
}

private extension TradingPairsViewModelImpl {
    func bindInput() {
        input.sink { [weak self] input in
            switch input {
            case .viewDidLoad:
                self?.forceRefreshSubject.send(())
            case let .search(text):
                self?.filterItems(with: text)
            case .forceRefresh:
                self?.forceRefreshSubject.send(())
            case .connectionIndicatorTapped:
                self?.handleConnectionIndicator()
            }
        }.store(in: &bin)
    }
    
    func filterItems(with query: String) {
        _output.send(.loaded(items: dataStore.filter(with: query)))
    }
    
    func updatePairs(with items: [TradingPairItemModel]) {
        _output.send(.updated(items: dataStore.update(items: items)))
    }
    
    func handleConnectionIndicator() {
        guard !dataStore.isEmpty else {
            _output.send(.showConnectionIssueAlert)
            return
        }
        
        forceRefreshSubject.send(())
    }
}

private extension TradingPairsViewModelImpl {
    /// ideally we'd want to use socket here instead of repeating http requests
    func setupRefreshValues() {
        refreshController
            .createRefresher()
            .merge(with: forceRefreshSubject)
            .compactMap { [weak self] _ in
                self?.service.loadTradingPairs()
            }
            .switchToLatest()
            .sink { [weak self] result in
                   guard let self = self else { return }
                   switch result {
                   case let .success(elems):
                       let itemsToDisplay = self.dataStore.update(items: elems)
                       self._output.send(.updated(items: itemsToDisplay))
                   case .failure(_):
                       self.handleLoadError()
                   }
            }.store(in: &bin)
    }
    
    func handleLoadError() {
        _output.send(.showConnectionIssueIndicator)
    }
}
