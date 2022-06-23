//
//  TradingPairsService.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Combine

protocol TradingPairsService {
    func loadTradingPairs() -> AnyPublisher<Result<[TradingPairItemModel], Error>, Never>
}
