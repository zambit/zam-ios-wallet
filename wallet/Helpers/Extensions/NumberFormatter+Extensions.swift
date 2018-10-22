//
//  NumberFormatter+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension NumberFormatter {

    static var output: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter
    }

    static func amount(minimumFractionDigits: Int, maximumFractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        if minimumFractionDigits > 0 {
            formatter.alwaysShowsDecimalSeparator = true
        }

        return formatter
    }

    static var walletAmountShort: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2

        return formatter
    }

    static var walletAmount: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 8

        return formatter
    }

    static func walletAmount(maximumFractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal

        if maximumFractionDigits > 0 {
            formatter.alwaysShowsDecimalSeparator = true
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = maximumFractionDigits
        } else {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        }
        return formatter
    }
}
