//
//  CodableSuccess.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

// Different templates of success responses from Wallet Remote API

struct CodableSuccessEmptyResponse: Codable {

    let result: Bool

    private enum CodingKeys: String, CodingKey {
        case result
    }
}

struct CodableSuccessAuthTokenResponse: Codable {

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

struct CodableSuccessSignUpTokenResponse: Codable {

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

struct CodableSuccessRecoveryTokenResponse: Codable {

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

struct CodableSuccessAuthorizedPhoneResponse: Codable {

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

struct CodableSuccessWalletResponse: Codable {

    let result: Bool
    let data: CodableWallet

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

}

struct CodableSuccessWalletsPageResponse: Codable {

    let result: Bool
    let data: WalletsPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct WalletsPage: Codable {
        let count: Int
        let next: String
        let wallets: [CodableWallet]

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case wallets
        }
    }
}

struct CodableWallet: Codable {

    let id: String
    let coin: String
    let name: String
    let address: String
    let balance: String

    private enum CodingKeys: String, CodingKey {
        case id
        case coin
        case name = "wallet_name"
        case address
        case balance
    }
}
