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

class UserContactsManager {

    private(set) static var `default`: UserContactsManager = UserContactsManager(fetchKeys: [.fullName, .phoneNumber, .avatar],
                                                                 phoneNumberFormatter: PhoneNumberFormatter())

    var contacts: [ContactData] = []

    let contactStore = CNContactStore()
    let fetchKeys: [UserContactFetchKey]
    let phoneNumberFormatter: PhoneNumberFormatter

    static var isAvailable: Bool {
        return CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .authorized
    }

    init(fetchKeys: [UserContactFetchKey], phoneNumberFormatter: PhoneNumberFormatter) {
        self.fetchKeys = fetchKeys
        self.phoneNumberFormatter = phoneNumberFormatter
    }

    func fetchContacts(_ completion: @escaping ([ContactData]) -> Void) {
        let success: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            guard let contacts = try? strongSelf.getContacts() else {
                return completion([])
            }

            let phones = contacts.map {
                contact in
                contact.phoneNumbers.compactMap {
                    $0.value.stringValue
                }
            }

            strongSelf.phoneNumberFormatter.getCompleted(from: phones) {
                formattedPhones in

                let result = contacts.enumerated().map { arg -> ContactData in
                    let name = arg.element.givenName + " " + arg.element.familyName
                    return ContactData(name: name, avatar: arg.element.thumbnailImageData, phoneNumbers: formattedPhones[arg.offset].compactMap({$0}))
                }

                strongSelf.contacts = result

                completion(result)
            }
        }

        if !UserContactsManager.isAvailable {
            contactStore.requestAccess(for: CNEntityType.contacts) {
                [weak self]
                (access, accessError) in
                if access {
                    success()
                }
                else {
                    self?.contacts = []
                    completion([])
                }
            }
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
