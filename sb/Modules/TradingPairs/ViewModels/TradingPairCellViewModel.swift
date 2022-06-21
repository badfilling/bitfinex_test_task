//
//  TradingPairCellViewModel.swift
//  sb
//
//  Created by Artur Stepaniuk on 21/06/2022.
//

import UIKit

struct TradingPairCellViewModel: Hashable {
    let coinIcon: UIImage?
    let coinFullName: String
    let coinSymbol: String
    let coinPrice: String
    let coinPriceChange: String
}
