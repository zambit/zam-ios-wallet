//
//  KYCData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct KYCPersonalInfoData: Equatable {

    let email: String
    let firstName: String
    let lastName: String
    let birthDate: Date
    let gender: GenderType
    let country: String

    let city: String
    let region: String
    let street: String
    let house: String
    let postalCode: Int

    init(email: String, firstName: String, lastName: String, birthDate: Date, gender: GenderType, country: String, city: String, region: String, street: String, house: String, postalCode: Int) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.gender = gender
        self.country = country
        self.city = city
        self.region = region
        self.street = street
        self.house = house
        self.postalCode = postalCode
    }

    init(codable: CodableKYCPersonalInfo.CodableInfoProperties) throws {
        self.email = codable.email
        self.firstName = codable.firstName
        self.lastName = codable.lastName

        self.birthDate = Date(unixTimestamp: codable.birthDate)

        guard let gender = GenderType(rawValue: codable.sex) else {
            throw KYCPersonalInfoDataError.genderTypeResponseFormatError
        }
        self.gender = gender

        self.country = codable.country
        self.city = codable.address.city
        self.region = codable.address.region
        self.street = codable.address.street
        self.house = codable.address.house
        self.postalCode = codable.address.postalCode
    }
}

enum KYCPersonalInfoDataError: Error {
    case genderTypeResponseFormatError
}
