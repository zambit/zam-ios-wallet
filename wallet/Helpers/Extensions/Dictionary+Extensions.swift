//
//  Dictionary+Extensions.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {

    /**
     Add key-value pair where value is optional. If value is nil, pair doesn't add.
     */
    mutating func addPair(key: Key, value: Value?) {
        guard let val = value else {
            return
        }

        self[key] = val
    }
}

extension Dictionary where Key == String, Value == String? {

    /**
     Returns copy of self with unwrapped values.
     */
    func unwrapped() -> [String: String] {
        var unwrapped: [String: String] = [:]

        for i in self {
            unwrapped.addPair(key: i.key, value: i.value)
        }

        return unwrapped
    }
}
