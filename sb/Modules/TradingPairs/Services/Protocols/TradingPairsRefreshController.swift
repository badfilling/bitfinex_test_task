//
//  TradingPairsRefreshController.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Combine
import Foundation

protocol TradingPairsRefreshController {
    func createRefresher() -> AnyPublisher<Void, Never>
}
