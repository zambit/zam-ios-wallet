//
//  UserDefaultsManager.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import Crashlytics

enum UserDefaultsError: Error {
    case noSavedPhoneForReceivingPin
    case noSavedPhoneForRemovingPin
}

struct UserDefaultsManager {

    private enum UserDefaultsKey: String {
        case phoneNumber = "phone_number"
        case token = "token"
    }

    private let userDefaults: UserDefaults
    private let keychainConfiguration: KeychainConfiguration

    init(userDefaults: UserDefaults = UserDefaults.standard, keychainConfiguration: KeychainConfiguration) {
        self.userDefaults = userDefaults
        self.keychainConfiguration = keychainConfiguration
    }

    func save(token: String) {
        userDefaults.set(token, forKey: UserDefaultsKey.token.rawValue)
    }

    func save(phoneNumber: String) {
        // set crashlytics user id as his phone number
        Crashlytics.sharedInstance().setUserIdentifier(phoneNumber)

        userDefaults.set(phoneNumber, forKey: UserDefaultsKey.phoneNumber.rawValue)
    }

    func save(pin: String, for accountName: String) throws {
        let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: keychainConfiguration.accessGroup)
        try passwordItem.savePassword(pin)
    }

    func save(phone: String, token: String) {
        save(phoneNumber: phone)
        save(token: token)
    }

    func getToken() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }

    func getPhoneNumber() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String
    }

    func getPin() throws -> String {
        guard let accountName = getPhoneNumber() else {
            throw UserDefaultsError.noSavedPhoneForReceivingPin
        }

        let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: keychainConfiguration.accessGroup)

        return try passwordItem.readPassword()
    }

    func clearToken() {
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)
    }

    func clearUserData() throws {
        if let accountName = getPhoneNumber() {
            let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                    account: accountName,
                                                    accessGroup: keychainConfiguration.accessGroup)

            try passwordItem.deleteItem()
        }
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKey.phoneNumber.rawValue)
    }

    func clearPin() throws {
        guard let accountName = getPhoneNumber() else {
            throw UserDefaultsError.noSavedPhoneForRemovingPin
        }

        let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: keychainConfiguration.accessGroup)

        try passwordItem.deleteItem()
    }

    var isUserAuthorized: Bool {
        return getToken() != nil
    }

    var isPhoneVerified: Bool {
        return getPhoneNumber() != nil
    }

    var isPinCreated: Bool {
        return (try? getPin()) != nil
    }
}
