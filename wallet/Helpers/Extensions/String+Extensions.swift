//
//  String+Extensions.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension String {

    init?(_ value: Int?) {
        guard let int = value else {
            return nil
        }

        self.init(int)
    }

    /**
     Adds a given prefix to self, if the prefix itself, or another required prefix does not yet exist in self.
     */
    mutating func addPrefixIfNeeded(_ prefix: String, requiredPrefix: String? = nil) {
        guard !self.hasPrefix(requiredPrefix ?? prefix) else {
            return
        }
        self = prefix + self
    }

    /**
     Returns characters with i-index in self.
     */
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    /**
     Returns substring with range in self.
     */
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }

    /**
     Returns copy of self string with capitalized first character.
     */
    var capitalizingFirst: String {
        return prefix(1).capitalized + dropFirst()
    }

    /**
     Capitalize first letter of self.
     */
    mutating func capitalizeFirst() {
        self = self.capitalizingFirst
    }
}
