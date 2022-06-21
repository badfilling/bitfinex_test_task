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
}

enum TradingPairsViewModelOutput {
    case loaded(items: [TradingPairCellViewModel])
}

class TradingPairsViewModelImpl: TradingPairsViewModel {
    let input: PassthroughSubject<TradingPairsViewModelInput, Never> = .init()
    
    var output: AnyPublisher<TradingPairsViewModelOutput, Never> {
        _output.eraseToAnyPublisher()
    }
    
    private let _output: PassthroughSubject<TradingPairsViewModelOutput, Never> = .init()
    
    private var bin = Set<AnyCancellable>()
    
    init() {
        bindInput()
    }
}

private extension TradingPairsViewModelImpl {
    func bindInput() {
        input.sink { [weak self] input in
            switch input {
            case .viewDidLoad:
                self?.loadPairs()
            }
        }.store(in: &bin)
    }
    
    func loadPairs() {
        _output.send(.loaded(items: mockedPairs()))
    }
    
    func mockedPairs() -> [TradingPairCellViewModel] {
        return [
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Tether USD",
                coinSymbol: "USDT",
                coinPrice: "$ 1.01",
                coinPriceChange: "+0.1%"
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "USD Coin",
                coinSymbol: "USDC",
                coinPrice: "$ 0.999",
                coinPriceChange: "-0.01%"
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "Binance Coin",
                coinSymbol: "BNB",
                coinPrice: "$ 416.2002",
                coinPriceChange: "+2.01%"
            ),
            .init(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "XRP",
                coinSymbol: "XRP",
                coinPrice: "$ 0.2351",
                coinPriceChange: "-2.3561%"
            )
        ]
    }
}
