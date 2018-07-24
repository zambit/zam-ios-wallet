//
//  RecoveryAPI.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct RecoveryAPI: NetworkService {

    private let provider: RecoveryProvider

    init(provider: RecoveryProvider) {
        self.provider = provider
    }

    func sendVerificationCode(to phone: String) {

    }

    func verifyRecoveringAccountPassword(passing verificationCode: String, hasBeenSentTo phone: String) {

    }

    func providePassword(_ password: String, confirmation: String, for phone: String, recoveryToken: String) {

    }
}
