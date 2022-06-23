//
//  TradingPairsServiceMock.swift
//  sbTests
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation
import Combine
@testable import sb

class TradingPairsServiceMock: TradingPairsService {
    
    var loadResult: Result<[TradingPairItemModel], Error> = .success([])
    var onLoadTradingPairs: (() -> Void)?
    
    func loadTradingPairs() -> AnyPublisher<Result<[TradingPairItemModel], Error>, Never> {
        onLoadTradingPairs?()
        return Just(loadResult)
            .eraseToAnyPublisher()
    }
}
