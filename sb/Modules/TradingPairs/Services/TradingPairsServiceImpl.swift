//
//  TradingPairsServiceImpl.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Combine
import UIKit

class TradingPairsServiceImpl: TradingPairsService {
    
    private let networkClient: NetworkClient
    private let mapper: TradingPairsMapper
    init(networkClient: NetworkClient, mapper: TradingPairsMapper) {
        self.networkClient = networkClient
        self.mapper = mapper
    }
    
    func loadTradingPairs() -> AnyPublisher<Result<[TradingPairItemModel], Error>, Never> {
        return networkClient.loadTradingPairs()
            .map { [weak self] loadResult in
                guard let self = self else { return .failure(CommonError.invalidSelf) }
                switch loadResult {
                
                case let .success(response):
                    let pairModels = self.mapper.map(response: response)
                    return .success(pairModels)
                case let .failure(error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
