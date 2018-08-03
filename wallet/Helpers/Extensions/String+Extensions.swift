//
//  String+Extensions.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension String {
    /**
     Adds a given prefix to self, if the prefix itself, or another required prefix does not yet exist in self.
     Omit `requiredPrefix` to check for the prefix itself.
     */
    mutating func addPrefixIfNeeded(_ prefix: String, requiredPrefix: String? = nil) {
        guard !self.hasPrefix(requiredPrefix ?? prefix) else {
            return
        }
        self = prefix + self
    }

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
