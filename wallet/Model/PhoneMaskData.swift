//
//  PhoneMaskData.swift
//  wallet
//
//  Created by  me on 15/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct PhoneMaskData {

    let countryId: String
    let countryName: String
    let phoneCode: String
    let phoneMask: String

    enum CodingKeys: String {

        case countryId = "country_id"
        case countryName = "country_name"
        case phoneMask = "phone_mask"
        case phoneCode = "phone_code"
    }

    enum DecodingError: Error {
        case failedToDecodeInputDictionary
    }

    init(dictionary: [String: String]) throws {

        guard
            let countryId = dictionary[CodingKeys.countryId.rawValue],
            let countryName = dictionary[CodingKeys.countryName.rawValue],
            let phoneMask = dictionary[CodingKeys.phoneMask.rawValue],
            let phoneCode = dictionary[CodingKeys.phoneCode.rawValue] else {
                throw DecodingError.failedToDecodeInputDictionary
        }

        self.countryId = countryId
        self.countryName = countryName
        self.phoneMask = phoneMask
        self.phoneCode = phoneCode
    }

}
