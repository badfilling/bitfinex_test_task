//
//  NetworkClient.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

import Foundation
import Combine

protocol NetworkClient {
    func loadTradingPairs() -> AnyPublisher<Result<[TradingPairResponse], NetworkError>, Never>
}

enum NetworkError: Error {
    case unknownError
    case decodingFailed
}
