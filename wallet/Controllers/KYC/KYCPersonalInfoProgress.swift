//
//  KYCPersonalInfoProgress.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

class KYCPersonalInfoProgress {

    enum Keys: Int {
        case email
        case firstName
        case lastName
        case birthDate
        case gender
        case country
        case city
        case region
        case street
        case house
        case postalCode
    }

    struct ProgressCompletion {
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
        let postalCode: String
    }

    var email: String? {
        didSet {
            checkForCompletion()
        }
    }
    var firstName: String? {
        didSet {
            checkForCompletion()
        }
    }
    var lastName: String? {
        didSet {
            checkForCompletion()
        }
    }
    var birthDate: Date? {
        didSet {
            checkForCompletion()
        }
    }
    var gender: GenderType? {
        didSet {
            checkForCompletion()
        }
    }
    var country: String? {
        didSet {
            checkForCompletion()
        }
    }
    var city: String? {
        didSet {
            checkForCompletion()
        }
    }
    var region: String? {
        didSet {
            checkForCompletion()
        }
    }
    var street: String? {
        didSet {
            checkForCompletion()
        }
    }
    var house: String? {
        didSet {
            checkForCompletion()
        }
    }
    var postalCode: String? {
        didSet {
            checkForCompletion()
        }
    }

    var data: KYCPersonaInfoProperties? {
        if let email = email,
            let firstName = firstName,
            let lastName = lastName,
            let birthDate = birthDate,
            let gender = gender,
            let country = country,
            let city = city,
            let region = region,
            let street = street,
            let house = house,
            let postalCodeString = postalCode,
            let postalCode = Int(postalCodeString) {

            return KYCPersonaInfoProperties(email: email,
                                      firstName: firstName,
                                      lastName: lastName,
                                      birthDate: birthDate,
                                      gender: gender,
                                      country: country,
                                      city: city,
                                      region: region,
                                      street: street,
                                      house: house,
                                      postalCode: postalCode)
        }

        return nil
    }

    var completionCallback: ((KYCPersonaInfoProperties) -> Void)?
    var incompletionCallback: (() -> Void)?

    var isCompleted: Bool {
        if let _ = email,
            let _ = firstName,
            let _ = lastName,
            let _ = birthDate,
            let _ = gender,
            let _ = country,
            let _ = city,
            let _ = region,
            let _ = street,
            let _ = house,
            let _ = postalCode {
            return true
        }

        return false
    }

    init() {}

    init(data: KYCPersonaInfoProperties) {
        email = data.email
        firstName = data.firstName
        lastName = data.lastName
        birthDate = data.birthDate
        gender = data.gender
        country = data.country
        city = data.city
        region = data.region
        street = data.street
        house = data.house
        postalCode = String(data.postalCode)
    }

    func getTextFor(indexPath: IndexPath) -> String? {
        let allProperties: [[String?]] = [[email, firstName, lastName, birthDate == nil ? nil : birthDate!.longFormatted, gender?.formatted], [country, city, region, street, house, postalCode]]

        return allProperties[indexPath.section][indexPath.row]
    }

    private func checkForCompletion() {
        if let progressCompletion = self.data {
            completionCallback?(progressCompletion)
        } else {
            incompletionCallback?()
        }
    }
}
