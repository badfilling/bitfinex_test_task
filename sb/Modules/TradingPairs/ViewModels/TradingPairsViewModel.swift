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
}

enum TradingPairsViewModelOutput {
    case loaded(items: [TradingPairItemModel])
    case updated(items: [TradingPairItemModel])
}

class TradingPairsViewModelImpl: TradingPairsViewModel {
    let input: PassthroughSubject<TradingPairsViewModelInput, Never> = .init()
    
    var output: AnyPublisher<TradingPairsViewModelOutput, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private let _output: PassthroughSubject<TradingPairsViewModelOutput, Never> = .init()
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
                self?.loadPairsOnStart()
            case let .search(text):
                self?.filterItems(with: text)
            }
        }.store(in: &bin)
    }
    
    func filterItems(with query: String) {
        _output.send(.loaded(items: dataStore.filter(with: query)))
    }
    
    func loadPairsOnStart() {
        service.loadTradingPairs()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(elems):
                    let items = self.dataStore.setup(with: elems)
                    self._output.send(.loaded(items: items))
                case .failure(_):
                    break
                }
            }.store(in: &bin)
    }
    
    func updatePairs(with items: [TradingPairItemModel]) {
        _output.send(.updated(items: dataStore.update(items: items)))
    }
}

private extension TradingPairsViewModelImpl {
    enum Const {
        static let refreshRate: TimeInterval = 20.0
    }
}

private extension TradingPairsViewModelImpl {
    /// ideally we'd want to use socket here instead of repeating http requests
    func setupRefreshValues() {
        refreshController
            .createRefresher()
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
                       break
                   }
            }.store(in: &bin)
        
    }
    
    func mockedPairs() -> [TradingPairItemModel] {
        return [
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Tether USD",
                coinSymbol: "USDT",
                coinPrice: "$ 1.01",
                coinPriceChange: "+0.1%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "USD Coin",
                coinSymbol: "USDC",
                coinPrice: "$ 0.999",
                coinPriceChange: "-0.01%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Binance Coin",
                coinSymbol: "BNB",
                coinPrice: "$ 416.2002",
                coinPriceChange: "+2.01%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP",
                coinSymbol: "XRP2",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP3",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP4",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP5",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP6",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP7",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP8",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            
        ]
    }
    
    func mockedPairs2() -> [TradingPairItemModel] {
        return [
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Tether USD",
                coinSymbol: "USDT",
                coinPrice: "$ 3.01",
                coinPriceChange: "+0.1%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "USD Coin",
                coinSymbol: "USDC",
                coinPrice: "$ 5.999",
                coinPriceChange: "-0.01%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Binance Coin",
                coinSymbol: "BNB",
                coinPrice: "$ 416.2002",
                coinPriceChange: "-2.01%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-22.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP3",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2751",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP4",
                coinSymbol: "XRP",
                coinPrice: "$ 11.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP5",
                coinSymbol: "XRP",
                coinPrice: "$ 6.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP6",
                coinSymbol: "XRP",
                coinPrice: "$ 8.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP7",
                coinSymbol: "XRP",
                coinPrice: "$ 22.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP8",
                coinSymbol: "XRP",
                coinPrice: "$ 88.2351",
                coinPriceChange: "-2.3561%", priceIncreased: false
            ),
        ]
    }
}
