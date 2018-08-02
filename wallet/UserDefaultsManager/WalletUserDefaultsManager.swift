//
//  UserManager.swift
//  wallet
//
//  Created by  me on 31/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletUserDefaultsManager {

    private enum UserDefaultsKey: String {
        case formattingMaskSpace = "formatting_mask_space"
        case formattingMaskSymbol = "formatting_mask_symbol"
        case formattingMask = "formatting_mask"
        case phoneNumber = "phone_number"
        case token = "token"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func save(token: String) {
        userDefaults.set(token, forKey: UserDefaultsKey.token.rawValue)
        print("WalletUserDefaultsManager: token \(token) saved")
    }

    func save(phoneNumber: String) {
        userDefaults.set(phoneNumber, forKey: UserDefaultsKey.phoneNumber.rawValue)
        print("WalletUserDefaultsManager: phone number \(phoneNumber) saved")
    }

    func save(mask: String, symbol: Character, space: Character) {
        userDefaults.set(mask, forKey: UserDefaultsKey.formattingMask.rawValue)
        userDefaults.set(symbol, forKey: UserDefaultsKey.formattingMaskSymbol.rawValue)
        userDefaults.set(space, forKey: UserDefaultsKey.formattingMaskSpace.rawValue)
        print("WalletUserDefaultsManager: mask \(mask) saved")
    }

    func getToken() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }

    func getPhoneNumber() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String
    }

    func getMaskData() -> (String, Character, Character)? {
        guard let mask = userDefaults.value(forKey: UserDefaultsKey.formattingMask.rawValue) as? String,
            let symbol = userDefaults.value(forKey: UserDefaultsKey.formattingMaskSymbol.rawValue) as? Character,
            let space = userDefaults.value(forKey: UserDefaultsKey.formattingMaskSpace.rawValue) as? Character else {
                return nil
        }

        return (mask, symbol, space)
    }

    func clearUserData() {
        userDefaults.removeObject(forKey: UserDefaultsKey.phoneNumber.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)

        print("WalletUserDefaultsManager: user data deleted")
    }

    var isUserAuthorized: Bool {
        return getToken() != nil
    }

    var isPhoneVerified: Bool {
        return getPhoneNumber() != nil
    }

}
