//
//  PhoneNumberFormatter.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PhoneNumberKit

struct PhoneNumber {
    public let numberString: String
    public let formattedString: String
    public let code: UInt64
    public let region: String?
}

class PhoneNumberFormatter {

    private let formatter: PhoneNumberKit
    private let partialFormatter: PartialFormatter
    private let allowedCharacters: CharacterSet

    private var _number: String?

    init(_ number: String, withPrefix: Bool = true) {
        self.formatter = PhoneNumberKit()
        self.partialFormatter = PartialFormatter(phoneNumberKit: formatter, withPrefix: withPrefix)
        self.allowedCharacters = CharacterSet(charactersIn: "1234567890")

        self.number = number
    }

    var completed: PhoneNumber? {
        guard let num = number, let object = try? formatter.parse(num) else {
            return nil
        }

        let united = String(object.countryCode) + String(object.nationalNumber)
        let unitedFormatted = PhoneNumberFormatter(united).formatted

        return PhoneNumber(numberString: united,
                           formattedString: unitedFormatted,
                           code: object.countryCode,
                           region: formatter.mainCountry(forCode: object.countryCode))
    }

    var isValid: Bool {
        return completed != nil
    }

    var number: String? {
        get {
            let separated = _number?.components(separatedBy: allowedCharacters.inverted)
            return separated?.joined(separator: "")
        }

        set {
            let separated = newValue?.components(separatedBy: allowedCharacters.inverted)
            _number = separated?.joined(separator: "")
        }
    }

    var formatted: String {
        get {
            return partialFormatter.formatPartial("+\(number ?? "")")
        }
    }

    var region: String? {
        get {
            guard let numCode = numericCode else {
                return nil
            }

            let region = formatter.countries(withCode: numCode)
            return region?.first
        }
    }

    var code: String? {
        get {
            if let numeric = numericCode {
                return String(numeric)
            }

            return nil
        }

        set {
            let newCode = newValue ?? ""

            let allowedCharacters = CharacterSet(charactersIn: "1234567890")
            let separated = newCode.components(separatedBy: allowedCharacters.inverted)
            let clearCode = separated.joined(separator: "")

            guard let number = self.number else {
                self.number = clearCode
                return
            }

            guard let oldCode = code else {
                self.number?.addPrefixIfNeeded(clearCode)
                return
            }

            var mutableNumber = number

            if mutableNumber.hasPrefix(oldCode) {
                let endIndex = mutableNumber.endIndex(of: oldCode)!
                mutableNumber.removeSubrange(mutableNumber.startIndex...endIndex)
            }

            mutableNumber.insert(contentsOf: newCode, at: mutableNumber.startIndex)
            self.number = number
        }
    }

    private var numericCode: UInt64? {
        get {
            let separated = formatted.split(separator: " ")

            if let expectedCode = separated.first {
                let allowedCharacters = CharacterSet(charactersIn: "1234567890")
                let separated = expectedCode.components(separatedBy: allowedCharacters.inverted)
                let clearCode = separated.joined(separator: "")

                guard let numCode = UInt64(clearCode) else {
                    return nil
                }

                if let _ = formatter.countries(withCode: numCode) {
                    return numCode
                }
            }

            return nil
        }
    }
}
