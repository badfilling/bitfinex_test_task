//
//  TradingPairsMapper.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation

protocol TradingPairsMapper {
    func map(response: [TradingPairResponse]) -> [TradingPairItemModel]
}
