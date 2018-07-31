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

    func getToken() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }

    func getPhoneNumber() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.phoneNumber.rawValue) as? String
    }

    var isUserAuthorized: Bool {
        return getToken() != nil
    }

    var isPhoneVerified: Bool {
        return getPhoneNumber() != nil
    }

}
