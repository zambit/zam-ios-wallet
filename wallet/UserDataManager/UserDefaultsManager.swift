//
//  UserDefaultsManager.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import Crashlytics

enum UserDataManagerError: Error {
    case noSavedPhoneForRemovingPin
}

struct UserDefaultsManager {

    private enum UserDefaultsKey: String {
        case formattingMaskSpace = "formatting_mask_space"
        case formattingMaskSymbol = "formatting_mask_symbol"
        case formattingMask = "formatting_mask"
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

    func save(phone: String, pin: String) throws {
        try save(pin: pin, for: phone)
        save(phoneNumber: phone)
    }

    func save(phone: String, pin: String, token: String) throws {
        try save(pin: pin, for: phone)
        save(phone: phone, token: token)
    }

    func getToken() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }

    func getPhoneNumber() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String
    }

    func getPin() throws -> String? {
        guard let accountName = getPhoneNumber() else {
            return nil
        }

        let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: keychainConfiguration.accessGroup)

        return try passwordItem.readPassword()
    }

    func getMaskData() -> (String, Character, Character)? {
        guard let mask = userDefaults.value(forKey: UserDefaultsKey.formattingMask.rawValue) as? String,
            let symbol = userDefaults.value(forKey: UserDefaultsKey.formattingMaskSymbol.rawValue) as? Character,
            let space = userDefaults.value(forKey: UserDefaultsKey.formattingMaskSpace.rawValue) as? Character else {
                return nil
        }

        return (mask, symbol, space)
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
            throw UserDataManagerError.noSavedPhoneForRemovingPin
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
        let flag = try? getPin()

        guard let pin = flag else {
            return false
        }

        return pin != nil
    }
}
