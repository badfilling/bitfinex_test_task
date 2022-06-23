//
//  TradingPairsDataStore.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

import Foundation

protocol TradingPairsDataStore {
    func setup(with items: [TradingPairItemModel]) -> [TradingPairItemModel]
    func update(items: [TradingPairItemModel]) -> [TradingPairItemModel]
    func filter(with query: String) -> [TradingPairItemModel]
}
