//
//  CodableKYCPersonalInfo.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableKYCPersonalInfo: Codable {

    let status: String
    let personalData: CodableProperties?

    private enum CodingKeys: String, CodingKey {
        case status
        case personalData = "personal_data"
    }

    struct CodableProperties: Codable {
        let email: String
        let firstName: String
        let lastName: String
        let birthDate: Double
        let sex: String
        let country: String
        let address: CodableAddress

        private enum CodingKeys: String, CodingKey {
            case email
            case firstName = "first_name"
            case lastName = "last_name"
            case birthDate = "birth_date"
            case sex
            case country
            case address
        }

        struct CodableAddress: Codable {
            let city: String
            let region: String
            let street: String
            let house: String
            let postalCode: Int

            private enum CodingKeys: String, CodingKey {
                case city
                case region
                case street
                case house
                case postalCode = "postal_code"
            }
        }
    }
}
