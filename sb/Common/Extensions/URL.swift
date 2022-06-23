//
//  URL.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation

extension URL {
    static func resolve(for endpoint: Endpoint, with query: [URLQueryItem], baseUrl: URL) -> URL? {
        let fullUrl = baseUrl.appendingPathComponent(endpoint.rawValue)
        var urlComponents = URLComponents(url: fullUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = query
        
        return urlComponents?.url
    }
}
