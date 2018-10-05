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
    let data: WalletPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct WalletPage: Codable {
        let wallet: CodableWallet

        private enum CodingKeys: String, CodingKey {
            case wallet
        }
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

struct CodableSuccessUserInfoResponse: Codable {

    let result: Bool
    let data: CodableUser

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }
}

struct CodableSuccessTransactionResponse: Codable {

    let result: Bool
    let data: Transaction

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct Transaction: Codable {
        let transaction: CodableTransaction

        private enum CodingKeys: String, CodingKey {
            case transaction
        }
    }
}

struct CodableSuccessTransactionsSearchingResponse: Codable {

    let result: Bool
    let data: TransactionsPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct TransactionsPage: Codable {
        let count: Int
        let next: String?
        let transactions: [CodableTransaction]

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case transactions
        }
    }
}

struct CodableSuccessTransactionsGroupedSearchingResponse: Codable {

    let result: Bool
    let data: GroupedTransactionsPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct GroupedTransactionsPage: Codable {
        let count: Int
        let next: String?
        let transactions: [CodableTransactionsGroup]?

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case transactions
        }
    }
}

struct CodableWallet: Codable {

    let id: String
    let coin: String
    let name: String
    let address: String
    let balances: CodableBalance

    private enum CodingKeys: String, CodingKey {
        case id
        case coin
        case name = "wallet_name"
        case address
        case balances
    }
}

struct CodableBalance: Codable {

    let zam: String?
    let eth: String?
    let btc: String?
    let bch: String?
    let usd: String

    private enum CodingKeys: String, CodingKey {
        case zam
        case eth
        case btc
        case bch
        case usd
    }
}

struct CodableUser: Codable {

    let id: String
    let phone: String
    let status: String
    let registeredAt: Decimal
    let wallets: CodableWallets

    private enum CodingKeys: String, CodingKey {
        case id
        case phone
        case status
        case registeredAt = "registered_at"
        case wallets
    }

    struct CodableWallets: Codable {
        let count: Int
        let totalBalance: CodableBalance

        private enum CodingKeys: String, CodingKey {
            case count
            case totalBalance = "total_balance"
        }
    }
}

struct CodableTransactionsGroup: Codable {

    let startDate: Double
    let endDate: Double
    let amount: CodableBalance
    let transactions: [CodableTransaction]

    private enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case amount = "total_amount"
        case transactions = "items"
    }
}

struct CodableTransaction: Codable {

    let id: String
    let direction: String
    let status: String
    let coin: String
    let sender: String?
    let recipient: String?
    let amount: CodableBalance

    private enum CodingKeys: String, CodingKey {
        case id
        case direction
        case status
        case coin
        case sender
        case recipient
        case amount
    }
}

struct CodableSuccessKYCPersonalInfoResponse: Codable {

    let result: Bool
    let data: CodableKYCPersonalInfo

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }
}

struct CodableKYCPersonalInfo: Codable {
    let status: String
    let personalData: CodableInfoProperties?

    private enum CodingKeys: String, CodingKey {
        case status
        case personalData = "personal_data"
    }

    struct CodableInfoProperties: Codable {
        let email: String
        let firstName: String
        let lastName: String
        let birthDate: Double
        let sex: String
        let country: String
        let address: CodableAddress

        private enum CodingKeys: String, CodingKey {
            case email
            case firstName = "first_name"
            case lastName = "last_name"
            case birthDate = "birth_date"
            case sex
            case country
            case address
        }

        struct CodableAddress: Codable {
            let city: String
            let region: String
            let street: String
            let house: String
            let postalCode: Int

            private enum CodingKeys: String, CodingKey {
                case city
                case region
                case street
                case house
                case postalCode = "postal_code"
            }
        }
    }
}

struct CodableHistoricalData: Codable {
    let data: [CodableHistoricalDataObject]
    let timeFrom: Double
    let timeTo: Double

    private enum CodingKeys: String, CodingKey {
        case data = "Data"
        case timeFrom = "TimeFrom"
        case timeTo = "TimeTo"
    }
}

struct CodableHistoricalDataObject: Codable {
    let time: Double
    let close: Decimal
    let high: Decimal
    let low: Decimal
    let open: Decimal
    let volumeFrom: Decimal
    let volumeTo: Decimal

    private enum CodingKeys: String, CodingKey {
        case time
        case close
        case high
        case low
        case open
        case volumeFrom = "volumefrom"
        case volumeTo = "volumeto"
    }
}