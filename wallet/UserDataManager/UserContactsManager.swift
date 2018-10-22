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

    private(set) static var `default`: UserContactsManager = UserContactsManager(
        fetchKeys: [.fullName, .phoneNumber, .avatar],
        phoneNumberFormatter: PhoneNumberFormatter()
    )

    private(set) var contacts: [Contact] = []

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

    func fetchContacts(_ completion: @escaping ([Contact]) -> Void) {
        let success: () -> Void = {
            DispatchQueue.global(qos: .default).async {
                guard let contacts = try? self.getContacts() else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                    return
                }

                let result = contacts.map { Contact(contact: $0) }
                self.contacts = result

                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }

        let failure: () -> Void = {
            self.contacts = []

            DispatchQueue.main.async {
                completion([])
            }
        }

        if !UserContactsManager.isAvailable {
            contactStore.requestAccess(for: CNEntityType.contacts) {
                (access, accessError) in

                if access {
                    success()
                } else {
                    failure()
                }
            }
        } else {
            success()
        }
    }

    func enumerateContacts(usingBlock block: @escaping (Contact) -> Void) throws {
        let fetchRequest = CNContactFetchRequest(keysToFetch: fetchKeys.map { $0.descriptor })

        try contactStore.enumerateContacts(with: fetchRequest) {
            (contact, last) in

            block(Contact(contact: contact))
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
