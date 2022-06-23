//
//  TradingPairsDataStoreMock.swift
//  sbTests
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation
@testable import sb

class TradingPairsDataStoreMock: TradingPairsDataStore {
    
    var itemsToReturnOnUpdate = [TradingPairItemModel]()
    var itemsToReturnOnFilter = [TradingPairItemModel]()
    var itemsReceivedOnUpdate = [TradingPairItemModel]()
    var onUpdate: (() -> Void)?
    var onFilter: (() -> Void)?
    var usedQuery = ""
    
    func update(items: [TradingPairItemModel]) -> [TradingPairItemModel] {
        onUpdate?()
        itemsReceivedOnUpdate = items
        return itemsToReturnOnUpdate
    }
    
    func filter(with query: String) -> [TradingPairItemModel] {
        onFilter?()
        usedQuery = query
        return itemsToReturnOnFilter
    }
}
