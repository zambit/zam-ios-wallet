//
//  WalletData.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 Struct represents user wallet.
 */
struct WalletData: Equatable {

    let id: String
    let name: String
    let coin: CoinType
    let balance: BalanceData
    let address: String

    init(codable: CodableWallet) throws {
        self.id = codable.id
        self.name = codable.name

        guard let coinType = CoinType(rawValue: codable.coin) else {
            throw WalletDataError.coinTypeReponseFormatError
        }

        self.coin = coinType
        do {
            let balance = try BalanceData(coin: coinType, codable: codable.balances)
            self.balance = balance
        } catch {
            throw WalletDataError.balanceFormatError
        }

        self.address = codable.address
    }

    init(id: String, name: String, coin: CoinType, balance: BalanceData, address: String) {
        self.id = id
        self.name = name
        self.coin = coin
        self.balance = balance
        self.address = address
    }
}

enum WalletDataError: Error {
    case coinTypeReponseFormatError
    case balanceFormatError
}

