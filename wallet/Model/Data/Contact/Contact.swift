//
//  Contact.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import ContactsUI

/**
 Structure representing contact extracted from system with needed information.
 */
struct Contact: Equatable {
    
    var name: String
    var avatarData: Data?
    var phoneNumbers: [String] = []

    init(contact: CNContact) {
        if contact.givenName.isEmpty && contact.familyName.isEmpty {
            self.name = contact.organizationName
        } else {
            self.name = contact.givenName + " " + contact.familyName
        }

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

    /**
     Convert current Contact object to `formatted` representation with converted first phone number.
     */
    func toFormatted(_ block: @escaping (FormattedContact?) -> Void) {
        let formatter = PhoneNumberFormatter()

        guard let phoneNumber = phoneNumbers.first else {
            let formattedContact = FormattedContact(name: self.name, avatarData: self.avatarData, formattedPhoneNumber: nil)
            return block(formattedContact)
        }

        formatter.getCompleted(from: phoneNumber) {
            phone in

            let formattedContact = FormattedContact(name: self.name, avatarData: self.avatarData, formattedPhoneNumber: phone?.formattedString)
            block(formattedContact)
        }
    }
}
