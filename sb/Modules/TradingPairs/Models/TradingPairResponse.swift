//
//  TradingPairResponse.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation

struct TradingPairResponse: ArrayResponseDecodable {
    let symbol: String
    let bid: Double
    let bidSize: Double
    let ask: Double
    let askSize: Double
    let dailyChange: Double
    let dailyChangeRelative: Double
    let lastPrice: Double
    let volume: Double
    let high: Double
    let low: Double
    
    init?(from rawData: Any) {
        guard let rawData = rawData as? [Any],
              let symbol = rawData[safe: 0] as? String,
              let bid = rawData[safe: 1] as? Double,
              let bidSize = rawData[safe: 2] as? Double,
              let ask = rawData[safe: 3] as? Double,
              let askSize = rawData[safe: 4] as? Double,
              let dailyChange = rawData[safe: 5] as? Double,
              let dailyChangeRelative = rawData[safe: 6] as? Double,
              let lastPrice = rawData[safe: 7] as? Double,
              let volume = rawData[safe: 8] as? Double,
              let high = rawData[safe: 9] as? Double,
              let low = rawData[safe: 10] as? Double else {
            return nil
        }
        
        self.symbol = symbol
        self.bid = bid
        self.bidSize = bidSize
        self.ask = ask
        self.askSize = askSize
        self.dailyChange = dailyChange
        self.dailyChangeRelative = dailyChangeRelative
        self.lastPrice = lastPrice
        self.volume = volume
        self.high = high
        self.low = low
    }
}
