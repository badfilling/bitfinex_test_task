//
//  TradingPairsDataStore.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

import Foundation

protocol TradingPairsDataStore {
    func update(items: [TradingPairItemModel]) -> [TradingPairItemModel]
    func filter(with query: String) -> [TradingPairItemModel]
}
