//
//  TradingPairsDataStoreImpl.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

class TradingPairsDataStoreImpl: TradingPairsDataStore {
    
    var items: [TradingPairItemModel] = []
    var filterQuery = ""
    
    func update(items: [TradingPairItemModel]) -> [TradingPairItemModel] {
        self.items = items
        return performFilter(with: filterQuery)
    }
    
    func filter(with query: String) -> [TradingPairItemModel] {
        filterQuery = query.lowercased()
        return performFilter(with: filterQuery)
    }
    
    func performFilter(with query: String) -> [TradingPairItemModel] {
        return query.isEmpty ?
        items :
        items.filter { $0.coinSymbol.lowercased().contains(query) }
    }
}
