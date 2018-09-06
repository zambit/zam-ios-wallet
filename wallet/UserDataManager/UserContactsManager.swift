//
//  UserContactsManager.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import ContactsUI

enum UserContactFetchKey {
    case fullName
    case phoneNumber
    case avatar

    var descriptor: CNKeyDescriptor {
        switch self {
        case .fullName:
            return CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        case .phoneNumber:
            return CNContactPhoneNumbersKey as CNKeyDescriptor
        case .avatar:
            return CNContactThumbnailImageDataKey as CNKeyDescriptor
        }
    }
}

struct UserContactsManager {

    let contactStore = CNContactStore()
    let fetchKeys: [UserContactFetchKey]
    let phoneNumberFormatter: PhoneNumberFormatter

    func fetchContacts(_ completion: @escaping ([ContactData]) -> Void) {
        guard let contacts = try? getContacts() else {
            return completion([])
        }

        let phones = contacts.map {
            contact in
            contact.phoneNumbers.compactMap {
                $0.value.stringValue
            }
        }

        phoneNumberFormatter.getCompleted(from: phones) {
            formattedPhones in

            let result = contacts.enumerated().map { arg -> ContactData in
                let name = arg.element.givenName + " " + arg.element.familyName
                return ContactData(name: name, avatar: arg.element.thumbnailImageData, phoneNumbers: formattedPhones[arg.offset].compactMap({$0}))
            }

            completion(result)
        }
    }

    func enumerateContacts(usingBlock block: @escaping (ContactData) -> Void) throws {
        let fetchRequest = CNContactFetchRequest(keysToFetch: fetchKeys.map { $0.descriptor })

        try contactStore.enumerateContacts(with: fetchRequest) {
            (contact, last) in

            block(ContactData(contact: contact))
        }
    }

    private func getContacts() throws -> [CNContact] {
        var containers: [CNContainer] = []

        containers = try contactStore.containers(matching: nil)

        var results: [CNContact] = []

        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: fetchKeys.map { $0.descriptor })

            results.append(contentsOf: containerResults)
        }

        return results
    }
}
