//
//  PhoneNumberFormatter.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PhoneNumberKit

/**
 *  Complete phone number structure that provides some detail info.
 */
struct PhoneNumber: Equatable {
    let numberString: String
    let formattedString: String
    let code: UInt64
    let region: String?
}

/**
 * Phone number formatter, providing interface to extract detail information, format partial and full phone numbers.
 */
class PhoneNumberFormatter {

    /**
     *  Format input free format string to only numbers format.
     *
     *  - parameter formatted: Free format string
     */
    static func trivialString(from formatted: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let separated = formatted.components(separatedBy: allowedCharacters.inverted)
        return separated.joined(separator: "")
    }

    private let formatter: PhoneNumberKit
    private let partialFormatter: PartialFormatter
    private let allowedCharacters: CharacterSet

    private var _number: String?

    /**
     *  Init formatter with specified number, if it's exist, or without to be available for partial formatting.
     *
     *  - parameter number: Initial number value.
     */
    init(_ number: String? = nil, withPrefix: Bool = true) {
        self.formatter = PhoneNumberKit()
        self.partialFormatter = PartialFormatter(phoneNumberKit: formatter, withPrefix: withPrefix)
        self.allowedCharacters = CharacterSet(charactersIn: "1234567890")

        self.number = number
    }

    /**
     *  Get completed phone number structure with detail information from given phone number string if it's valid.
     *
     *  It's asynchronous operation, and returns result with completion block.
     *
     *  - parameter string: Phone number to be converting to completed.
     *  - parameter completion: Result of creating completed structure from given phone number.
     */
    func getCompleted(from string: String, completion: @escaping (PhoneNumber?) -> Void) {
        let target = self
        
        DispatchQueue.global(qos: .default).async {
            let parsed = try? target.formatter.parse(string)

            if let parsed = parsed, !parsed.notParsed() {

                let united = String(parsed.countryCode) + String(parsed.nationalNumber)
                let unitedFormatted = PhoneNumberFormatter(united).formatted

                let object = PhoneNumber(numberString: united,
                                         formattedString: unitedFormatted,
                                         code: parsed.countryCode,
                                         region: target.formatter.mainCountry(forCode: parsed.countryCode))
                DispatchQueue.main.async {
                    completion(object)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    /**
     *  Get completed phone numbers structures with detail information if phones is valid.
     *
     *  It's asynchronous operation, and returns result with completion block.
     *
     *  - parameter array: Array of phone numbers to be converting to completed.
     *  - parameter completion: Result of creating completed structures from given array of phone numbers.
     */
    func getCompleted(from array: [String], completion: @escaping ([PhoneNumber?]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let parsed = strongSelf.formatter.parse(array, ignoreType: false, shouldReturnFailedEmptyNumbers: true)
            let result: [PhoneNumber?] = parsed.map {
                if $0.notParsed() {
                    return nil
                } else {
                    let united = String($0.countryCode) + String($0.nationalNumber)
                    let unitedFormatted = PhoneNumberFormatter(united).formatted

                    let object = PhoneNumber(numberString: united,
                                             formattedString: unitedFormatted,
                                             code: $0.countryCode,
                                             region: strongSelf.formatter.mainCountry(forCode: $0.countryCode))
                    return object
                }
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func getCompleted(from array: [[String]], completion: @escaping ([[PhoneNumber?]]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            var counters: [Int: Int] = [:]
            var prepared: [String] = []

            for i in array.enumerated() {
                for j in i.element {
                    prepared.append(j)
                    counters[prepared.count - 1] = i.offset
                }
            }

            let parsed = strongSelf.formatter.parse(prepared, ignoreType: false, shouldReturnFailedEmptyNumbers: true)
            var result = [[PhoneNumber?]](repeating: [], count: array.count)

            for i in parsed.enumerated() {
                let index = counters[i.offset]!
                let element = i.element
                if !element.notParsed() {
                    let united = String(element.countryCode) + String(element.nationalNumber)
                    let unitedFormatted = PhoneNumberFormatter(united).formatted

                    let object = PhoneNumber(numberString: united,
                                             formattedString: unitedFormatted,
                                             code: element.countryCode,
                                             region: strongSelf.formatter.mainCountry(forCode: element.countryCode))
                    result[index].append(object)
                } else {
                    result[index].append(nil)
                }
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    // MARK: - Setters

    /**
     * Set phone number for formatter.
     */
    var number: String? {
        get {
            let separated = _number?.components(separatedBy: allowedCharacters.inverted)
            return separated?.joined(separator: "")
        }

        set {
            let separated = newValue?.components(separatedBy: allowedCharacters.inverted)
            let string = separated?.joined(separator: "")
            _number = string
        }
    }

    // MARK: - Default values

    /**
     * Default phone code defined from user's device mobile information. Doesn't depend on formatter's phone.
     */
    var defaultCode: String? {
        if let numCode = formatter.countryCode(for: partialFormatter.currentRegion) {
            return String(numCode)
        }

        return nil
    }

    /**
     * Default phone region defined from user's device mobile information. Doesn't depend on formatter's phone.
     */
    var defaultRegion: String {
        return partialFormatter.currentRegion
    }

    // MARK: - Getters

    /**
     * Detect if current formatter's phone number is valid. It shows if partial entering completed.
     */
    var isValid: Bool {
        return completed != nil
    }

    /**
     * Code part of the phone.
     */
    var code: String? {
        get {
            if let numeric = numericCode {
                return String(numeric)
            }

            return nil
        }
    }

    /**
     * Completed phone number structure with detail information from formatter's phone number string if it's valid.
     */
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

    /**
     * Formatted phone number string contains symbols: +, (, ), -.
     */
    var formatted: String {
        get {
            if let number = number {
                return partialFormatter.formatPartial("+\(number)")
            }

            return ""
        }
    }

    /**
     * Region of formatter's phone number. Can be defined only by code part.
     */
    var region: String? {
        guard let numCode = numericCode else {
            return nil
        }

        return formatter.mainCountry(forCode: numCode)
    }

    private var numericCode: UInt64? {
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
