//
//  Decimal+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Decimal {

    enum FormattingType {
        case long
        case short
        case smart
        case largeDecimals
    }

    enum FormattingError: Error {
        case formattingDecimalFailed
    }

    func format(to type: FormattingType) throws -> String {
        var string: String?

        switch type {
        case .long:
            string = longFormatted
        case .short:
            string = shortFormatted
        case .smart:
            string = formatted
        case .largeDecimals:
            string = largeFormatted
        }

        guard let value = string else {
            throw FormattingError.formattingDecimalFailed
        }

        return value
    }
}

extension Decimal {

    var formatted: String? {

        if abs(self) >= 1000 {
            return NumberFormatter.amount(minimumFractionDigits: 0, maximumFractionDigits: 0).string(from: self as NSNumber)
        }

        if abs(self) >= 100 {
            return NumberFormatter.amount(minimumFractionDigits: 1, maximumFractionDigits: 2).string(from: self as NSNumber)
        }

        if abs(self) >= 1 {
            return NumberFormatter.amount(minimumFractionDigits: 1, maximumFractionDigits: 3).string(from: self as NSNumber)
        }

        return NumberFormatter.amount(minimumFractionDigits: 2, maximumFractionDigits: 5).string(from: self as NSNumber)
    }

    var largeFormatted: String? {

        if abs(self) >= 1000000000 {
            let value = self.doubleValue / 1000000000.0
            guard let string = NumberFormatter.amount(minimumFractionDigits: 0,
                                                      maximumFractionDigits: 1).string(from: value as NSNumber) else {
                                                        return nil
            }

            return string.appending("B")
        }

        if abs(self) >= 1000000 {
            let value = self.doubleValue / 1000000.0
            guard let string = NumberFormatter.amount(minimumFractionDigits: 0,
                                                      maximumFractionDigits: 1).string(from: value as NSNumber) else {
                                                        return nil
            }

            return string.appending("M")
        }

        if abs(self) >= 10000 {
            let value = self.doubleValue / 1000.0
            guard let string = NumberFormatter.amount(minimumFractionDigits: 0,
                                                      maximumFractionDigits: 1).string(from: value as NSNumber) else {
                                                        return nil
            }

            return string.appending("K")
        }

        return formatted
    }

    var longFormatted: String? {
        return NumberFormatter.amount(minimumFractionDigits: 1, maximumFractionDigits: 8).string(from: self as NSNumber)
    }

    var shortFormatted: String? {
        return NumberFormatter.amount(minimumFractionDigits: 1, maximumFractionDigits: 2).string(from: self as NSNumber)
    }
}

extension Decimal {

    var intValue: Int {
        return NSDecimalNumber(decimal: self).intValue
    }

    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
