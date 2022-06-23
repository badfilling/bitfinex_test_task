//
//  TradingPairsRefreshControllerImpl.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation
import Combine

class TradingPairsRefreshControllerImpl: TradingPairsRefreshController {
    
    private let refreshRate: TimeInterval
    
    init(refreshRate: TimeInterval) {
        self.refreshRate = refreshRate
    }
    
    func createRefresher() -> AnyPublisher<Date, Never> {
        Timer
            .publish(every: refreshRate, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
    }
}
