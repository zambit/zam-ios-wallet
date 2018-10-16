//
//  Wallet.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 Struct represents user wallet.
 */
struct Wallet: Equatable {

    let id: String
    let name: String
    let coin: CoinType
    let balance: Balance
    let address: String

    init(codable: CodableWallet) throws {
        self.id = codable.id
        self.name = codable.name

        guard let coinType = CoinType(rawValue: codable.coin) else {
            throw WalletDataError.coinTypeInputFormatError
        }

        self.coin = coinType
        do {
            let balance = try Balance(coin: coinType, codable: codable.balances)
            self.balance = balance
        } catch {
            throw WalletDataError.balanceInputFormatError
        }

        self.address = codable.address
    }

    init(id: String, name: String, coin: CoinType, balance: Balance, address: String) {
        self.id = id
        self.name = name
        self.coin = coin
        self.balance = balance
        self.address = address
    }
}

enum WalletDataError: Error {
    
    case coinTypeInputFormatError
    case balanceInputFormatError
}

