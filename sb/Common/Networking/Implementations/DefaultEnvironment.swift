//
//  DefaultEnvironment.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import Foundation

struct DefaultEnvironment: Environment {
    var baseUrl: URL {
        return URL(string: "https://api-pub.bitfinex.com/v2")!
    }
}
