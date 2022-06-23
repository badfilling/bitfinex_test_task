//
//  TradingPairsMapperImpl.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import UIKit

class TradingPairsMapperImpl: TradingPairsMapper {
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = 4
        return formatter
    }()
    
    func map(response: [TradingPairResponse]) -> [TradingPairItemModel] {
        response.map { raw in
            let coinSymbol = String(raw.symbol
                .replacingOccurrences(of: ":", with: "")
                .replacingOccurrences(of: "USD", with: "")
                .dropFirst())
            
            let dailyChangePercent = raw.dailyChangeRelative * 100
            let priceIncreased = !dailyChangePercent.isLess(than: .zero)
            
            let priceChangeValue = formatter.string(from: dailyChangePercent as NSNumber)!
            let lastPriceValue = formatter.string(from: raw.lastPrice as NSNumber)!
            let priceChange = "\(priceIncreased ? "+" : "")\(priceChangeValue)%"
            return TradingPairItemModel(
                coinIcon: UIImage(systemName: "bitcoinsign.circle.fill"),
                coinFullName: "\(coinSymbol) to USD",
                coinSymbol: coinSymbol,
                coinPrice: "$ \(lastPriceValue)",
                coinPriceChange: priceChange,
                priceIncreased: priceIncreased)
        }
    }
}
