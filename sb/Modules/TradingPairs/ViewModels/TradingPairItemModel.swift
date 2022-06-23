//
//  TradingPairItemModel.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit

struct TradingPairItemModel: Hashable {
    
    let id: String
    let coinIcon: UIImage?
    let coinFullName: String
    let coinSymbol: String
    let coinPrice: String
    let coinPriceChange: String
    let priceIncreased: Bool
    
    init(
        coinIcon: UIImage?,
        coinFullName: String,
        coinSymbol: String,
        coinPrice: String,
        coinPriceChange: String,
        priceIncreased: Bool
    ) {
        self.id = coinFullName
        self.coinIcon = coinIcon
        self.coinFullName = coinFullName
        self.coinSymbol = coinSymbol
        self.coinPrice = coinPrice
        self.coinPriceChange = coinPriceChange
        self.priceIncreased = priceIncreased
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: TradingPairItemModel, rhs: TradingPairItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}
