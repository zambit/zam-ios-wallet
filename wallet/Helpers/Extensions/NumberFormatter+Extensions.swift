//
//  NumberFormatter+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension NumberFormatter {

    static var walletRemoteFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 6

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
        formatter.maximumFractionDigits = 6

        return formatter
    }
}
