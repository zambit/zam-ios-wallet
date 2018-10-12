//
//  Decimal+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Decimal {

    var formatted: String? {
        return NumberFormatter.walletAmount.string(from: self as NSNumber)
    }

    var shortFormatted: String? {
        return NumberFormatter.walletAmountShort.string(from: self as NSNumber)
    }
}
