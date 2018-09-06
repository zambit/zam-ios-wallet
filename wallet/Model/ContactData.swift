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
    var phoneNumbers: [PhoneNumber] = []

    init(contact: CNContact) {
        self.name = contact.givenName + " " + contact.familyName
        self.avatarData = contact.thumbnailImageData

        phoneNumbers = contact.phoneNumbers.compactMap {
            let phoneNumber = PhoneNumberFormatter($0.value.stringValue)
            return phoneNumber.completed
        }
    }

    init(name: String, avatar: Data?, phoneNumbers: [PhoneNumber]) {
        self.name = name
        self.avatarData = avatar
        self.phoneNumbers = phoneNumbers
    }
}
