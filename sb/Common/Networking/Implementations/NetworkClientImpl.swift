//
//  NetworkClientImpl.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

import Foundation
import Combine

class NetworkClientImpl: NetworkClient {
    
    private let session: URLSession
    private let environment: Environment
    private let tradingPairsQuery = URLQueryItem(
        name: "symbols",
        value:"tBTCUSD,tETHUSD,tCHSB:USD,tLTCUSD,tXRPUSD,tDSHUSD,tRRTUSD,tEOSUSD,tSANUSD,tDATUSD,tSNTUSD,tDOGE:USD,tMATIC:USD,tNEXO:USD,tOCEAN:USD,tBEST:USD,tAAVE:USD,tPLUUSD,tFILUSD"
    )
    
    init(session: URLSession, environment: Environment) {
        self.session = session
        self.environment = environment
    }
    
    func loadTradingPairs() -> AnyPublisher<Result<[TradingPairResponse], NetworkError>, Never> {
        guard let url = URL.resolve(
            for: .tickers,
            with: [tradingPairsQuery],
            baseUrl: environment.baseUrl
        ) else {
            return Just(.failure(.unknownError))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .decodeJson()
            .eraseToAnyPublisher()
    }
}
