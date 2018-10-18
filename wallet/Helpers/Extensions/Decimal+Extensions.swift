//
//  Decimal+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Decimal {

    var longFormatted: String? {
        return NumberFormatter.walletAmount.string(from: self as NSNumber)
    }

    var shortFormatted: String? {
        return NumberFormatter.walletAmountShort.string(from: self as NSNumber)
    }

    var formatted: String? {
        if self >= 1000 {
            return NumberFormatter.walletAmount(maximumFractionDigits: 0).string(from: self as NSNumber)
        }

        if self >= 100 {
            return NumberFormatter.walletAmount(maximumFractionDigits: 2).string(from: self as NSNumber)
        }

        if self >= 1 {
            return NumberFormatter.walletAmount(maximumFractionDigits: 3).string(from: self as NSNumber)
        }

        
        return NumberFormatter.walletAmount(maximumFractionDigits: 5).string(from: self as NSNumber)
    }

}

extension Decimal {

    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
