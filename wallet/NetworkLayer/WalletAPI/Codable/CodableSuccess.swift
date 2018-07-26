//
//  CodableSuccess.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

// Different templates of success responses from Wallet Remote API

struct CodableSuccessEmptyData: Codable {

    let result: Bool

    private enum CodingKeys: String, CodingKey {
        case result
    }
}

struct CodableSuccessAuthTokenData: Codable {

    let result: Bool
    let data: Token

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct Token: Codable {
        let token: String

        private enum CodingKeys: String, CodingKey {
            case token
        }
    }
}

struct CodableSuccessSignUpTokenData: Codable {

    let result: Bool
    let data: SignupToken

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct SignupToken: Codable {
        let token: String

        private enum CodingKeys: String, CodingKey {
            case token = "signup_token"
        }
    }
}

struct CodableSuccessRecoveryTokenData: Codable {

    let result: Bool
    let data: RecoveryToken

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct RecoveryToken: Codable {
        let token: String

        private enum CodingKeys: String, CodingKey {
            case token = "recovery_token"
        }
    }
}

struct CodableSuccessAuthorizedPhoneData: Codable {

    let result: Bool
    let data: Phone

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct Phone: Codable {
        let phone: String

        private enum CodingKeys: String, CodingKey {
            case phone
        }
    }
}
