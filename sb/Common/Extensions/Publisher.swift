//
//  Publisher.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Combine
import Foundation

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func decodeJson<T: ArrayResponseDecodable>() -> AnyPublisher<Result<[T], NetworkError>, Never> {
        return map { (data, response) -> Result<[T], NetworkError> in
            guard let jsonRaw = try? JSONSerialization.jsonObject(with: data) else {
                return .failure(.unknownError)
            }
            
            let responseArray = jsonRaw as? [Any] ?? []
            var responseElements = [T]()
            for rawValue in responseArray {
                if let element = T(from: rawValue) {
                    responseElements.append(element)
                }
            }
            return .success(responseElements)
        }
        .replaceError(with: .failure(NetworkError.unknownError))
        .eraseToAnyPublisher()
    }
}
