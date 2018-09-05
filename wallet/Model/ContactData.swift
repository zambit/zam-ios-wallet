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
    var phoneNumbers: [String] = [String]()

    init(contact: CNContact) {
        self.name = contact.givenName + " " + contact.familyName
        self.avatarData = contact.thumbnailImageData

        for phone in contact.phoneNumbers {
            let allowedCharacters = CharacterSet(charactersIn: "+1234567890")
            let formatted = phone.value.stringValue.components(separatedBy: allowedCharacters.inverted).joined(separator: "")
            phoneNumbers.append(formatted)
        }
    }
}
