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

/**
 User contacts controller. Provide interface to fetch contacts by different ways.
 */
class UserContactsManager {

    /**
     Static property for getting default instance of this class.
     */
    static let `default`: UserContactsManager = UserContactsManager(
        contactsStore: CNContactStore(),
        fetchKeys: [.fullName, .phoneNumber, .avatar],
        phoneNumberFormatter: PhoneNumberFormatter()
    )

    private(set) var contacts: [Contact] = []

    let contactsStore: CNContactStore
    let fetchKeys: [UserContactFetchKey]
    let phoneNumberFormatter: PhoneNumberFormatter

    /**
     Is contacts access authorized
     */
    static var isAvailable: Bool {
        return CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .authorized
    }

    init(contactsStore: CNContactStore, fetchKeys: [UserContactFetchKey], phoneNumberFormatter: PhoneNumberFormatter) {
        self.contactsStore = contactsStore
        self.fetchKeys = fetchKeys
        self.phoneNumberFormatter = phoneNumberFormatter
    }

    /**
     Fetch contacts asynchronously, parsing it to Contact structure.
     */
    func fetchContacts(_ completion: @escaping ([Contact]) -> Void) {

        // Success block
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

        // Failure block
        let failure: () -> Void = {
            self.contacts = []

            DispatchQueue.main.async {
                completion([])
            }
        }

        guard !UserContactsManager.isAvailable else {
            return success()
        }

        contactsStore.requestAccess(for: CNEntityType.contacts) {
            (access, accessError) in

            if access {
                success()
            } else {
                failure()
            }
        }
    }

    /**
     Fetch user contacts from system synchronously.
     */
    private func getContacts() throws -> [CNContact] {
        var containers: [CNContainer] = []

        containers = try contactsStore.containers(matching: nil)

        var results: [CNContact] = []

        for container in containers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let containerResults = try contactsStore.unifiedContacts(matching: fetchPredicate, keysToFetch: fetchKeys.map { $0.descriptor })

            results.append(contentsOf: containerResults)
        }

        return results
    }
}
