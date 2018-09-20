//
//  ContactData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import ContactsUI

struct ContactData {

    var name: String
    var avatarData: Data?
    var phoneNumbers: [String] = []

    init(contact: CNContact) {
        self.name = contact.givenName + " " + contact.familyName
        self.avatarData = contact.thumbnailImageData

        phoneNumbers = contact.phoneNumbers.compactMap {
            let phoneNumber = PhoneNumberFormatter.trivialString(from: $0.value.stringValue)
            return phoneNumber
        }
    }

    init(name: String, avatar: Data?, phoneNumbers: [String]) {
        self.name = name
        self.avatarData = avatar
        self.phoneNumbers = phoneNumbers
    }

    func toFormatted(_ block: @escaping (FormattedContactData?) -> Void) {
        let formatter = PhoneNumberFormatter()

        guard let phoneNumber = phoneNumbers.first else {
            return block(nil)
        }

        formatter.getCompleted(from: phoneNumber) {
            phone in

            if let formattedPhone = phone?.formattedString {
                let formattedContact = FormattedContactData(name: self.name, avatarData: self.avatarData, formattedPhoneNumber: formattedPhone)
                block(formattedContact)
                return
            }

            block(nil)
        }
    }
}
