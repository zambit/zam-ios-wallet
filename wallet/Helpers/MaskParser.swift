//
//  MaskMatching.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct MaskParser {

    let symbol: Character
    let space: Character

    init(symbol: Character, space: Character) {
        self.symbol = symbol
        self.space = space
    }

    func matchingUnstrict(text: String, withMask mask: String) -> String {
        var resulting: String = matchingStrict(text: text, withMask: mask)

        if resulting.count < text.count {
            let remained = text[resulting.count..<text.count]
            resulting.append(contentsOf: remained)
        }

        return resulting
    }

    func matchingStrict(text: String, withMask mask: String) -> String {

        var resulting: String = ""
        var textIndex: Int = 0

        for character in mask {
            if !(textIndex < text.count) {
                return resulting
            }

            switch character {
            case space:
                resulting.append(space)

                if text[textIndex] == space {
                    textIndex += 1
                }

            case symbol:
                while textIndex < text.count && text[textIndex] == space {
                    textIndex += 1
                }

                if textIndex < text.count {
                    resulting.append(text[textIndex])

                    textIndex += 1
                } 

            default:
                fatalError()
            }
        }

        return resulting
    }
}
