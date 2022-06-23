//
//  TradingPairsRefreshControllerMock.swift
//  sbTests
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation
import Combine
@testable import sb

class TradingPairsRefreshControllerMock: TradingPairsRefreshController {
    
    var onCreateRefresher: (() -> Void)?
    var publisherToReturn: AnyPublisher<Void, Never>?
    
    func createRefresher() -> AnyPublisher<Void, Never> {
        onCreateRefresher?()
        if let publisherToReturn = publisherToReturn {
            return publisherToReturn
        }
        return Just(()).eraseToAnyPublisher()
    }
}
