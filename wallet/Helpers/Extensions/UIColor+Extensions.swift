//
//  UIColor+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

// MARK: UIColor Helper
extension UIColor {

    /// Returns random generated color.
    open static var random: UIColor {
        srandom(arc4random())
        var red: Double = 0

        while (red < 0.1 || red > 0.84) {
            red = drand48()
        }

        var green: Double = 0
        while (green < 0.1 || green > 0.84) {
            green = drand48()
        }

        var blue: Double = 0
        while (blue < 0.1 || blue > 0.84) {
            blue = drand48()
        }

        return .init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }

    open static func colorHash(name: String?) -> UIColor {
        guard let name = name else {
            return .red
        }

        var nameValue = 0
        for character in name {
            let characterString = String(character)
            let scalars = characterString.unicodeScalars
            nameValue += Int(scalars[scalars.startIndex].value)
        }

        var r = Float((nameValue * 123) % 51) / 51
        var g = Float((nameValue * 321) % 73) / 73
        var b = Float((nameValue * 213) % 91) / 91

        let defaultValue: Float = 0.84
        r = min(max(r, 0.1), defaultValue)
        g = min(max(g, 0.1), defaultValue)
        b = min(max(b, 0.1), defaultValue)

        return .init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
}
