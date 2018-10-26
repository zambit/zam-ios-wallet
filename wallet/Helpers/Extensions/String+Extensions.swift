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

    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    func deletingLeading(character: Character) -> String {
        return self.split(separator: character).joined(separator: String(character))
    }

    /**
     Adds a given suffix to self, if the suffix itself, or another required suffix does not yet exist in self.
     */
    mutating func addSuffixIfNeeded(_ suffix: String, requiredSuffix: String? = nil) {
        guard !self.hasSuffix(requiredSuffix ?? suffix) else {
            return
        }
        self = self + suffix
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

    var removingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}

// MARK: String Helper
extension String {

    public var initials: String {
        var finalString = String()
        var words = components(separatedBy: .whitespacesAndNewlines)

        if let firstCharacter = words.first?.first {
            finalString.append(String(firstCharacter))
            words.removeFirst()
        }

        if let lastCharacter = words.last?.first {
            finalString.append(String(lastCharacter))
        }

        return finalString.uppercased()
    }
}
