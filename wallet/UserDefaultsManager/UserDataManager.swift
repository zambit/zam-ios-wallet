//
//  UserManager.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct UserDataManager {

    private enum UserDefaultsKey: String {
        case formattingMaskSpace = "formatting_mask_space"
        case formattingMaskSymbol = "formatting_mask_symbol"
        case formattingMask = "formatting_mask"
        case phoneNumber = "phone_number"
        case token = "token"
        case pin = "pin"
    }

    private let userDefaults: UserDefaults
    private let keychainConfiguration: KeychainConfiguration

    init(userDefaults: UserDefaults = UserDefaults.standard, keychainConfiguration: KeychainConfiguration) {
        self.userDefaults = userDefaults
        self.keychainConfiguration = keychainConfiguration
    }

    func save(token: String) {
        userDefaults.set(token, forKey: UserDefaultsKey.token.rawValue)
        print("WalletUserDefaultsManager: token \(token) saved")
    }

    func save(phoneNumber: String) {
        userDefaults.set(phoneNumber, forKey: UserDefaultsKey.phoneNumber.rawValue)
        print("WalletUserDefaultsManager: phone number \(phoneNumber) saved")
    }

    func save(password: String, for accountName: String) throws {
        let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: keychainConfiguration.accessGroup)

        try passwordItem.savePassword(password)
        print("WalletUserDefaultsManager: password \(password) saved")
    }

    func save(pin: String) {
        userDefaults.set(pin, forKey: UserDefaultsKey.pin.rawValue)
        print("WalletUserDefaultsManager: pin \(pin) saved")
    }

    func save(phone: String, password: String) throws {
        try save(password: password, for: phone)
        save(phoneNumber: phone)
    }

    func save(phone: String, password: String, token: String) throws {
        try save(password: password, for: phone)
        save(phoneNumber: phone)
        save(token: token)
    }

    func save(mask: String, symbol: Character, space: Character) {
        userDefaults.set(mask, forKey: UserDefaultsKey.formattingMask.rawValue)
        userDefaults.set(symbol, forKey: UserDefaultsKey.formattingMaskSymbol.rawValue)
        userDefaults.set(space, forKey: UserDefaultsKey.formattingMaskSpace.rawValue)
        print("WalletUserDefaultsManager: mask \(mask) saved")
    }

    func getToken() -> String? {
        print("WalletUserDefaultsManager: get \(userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String) token")
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }

    func getPhoneNumber() -> String? {
        print("WalletUserDefaultsManager: get \(userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String) phone")
        return userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String
    }

    func getPin() -> String? {
        print("WalletUserDefaultsManager: get \(userDefaults.value(forKey: UserDefaultsKey.pin.rawValue) as? String) pin")
        return userDefaults.value(forKey: UserDefaultsKey.pin.rawValue) as? String
    }

    func getPassword() throws -> String? {
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

    func clearUserData() throws {
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKey.pin.rawValue)

        if let accountName = getPhoneNumber() {
            let passwordItem = KeychainPasswordItem(service: keychainConfiguration.serviceName,
                                                    account: accountName,
                                                    accessGroup: keychainConfiguration.accessGroup)

            try passwordItem.deleteItem()
        }
        userDefaults.removeObject(forKey: UserDefaultsKey.phoneNumber.rawValue)

        print("WalletUserDefaultsManager: user data deleted")
    }

    func clearPin() {
        userDefaults.removeObject(forKey: UserDefaultsKey.pin.rawValue)

        print("WalletUserDefaultsManager: pin deleted")
    }

    var isUserAuthorized: Bool {
        return getToken() != nil
    }

    var isPhoneVerified: Bool {
        return getPhoneNumber() != nil
    }

    var isPinCreated: Bool {
        return getPin() != nil
    }

}
