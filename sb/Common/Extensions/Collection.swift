//
//  Collection.swift
//  sb
//
//  Created by Artur Stepaniuk on 22/06/2022.
//

import Foundation
extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
