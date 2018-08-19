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
struct WalletData {

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
        self.balance = BalanceData(coin: coinType, codable: codable.balances)
        self.address = codable.address
    }
    
}

enum WalletDataError: Error {
    case coinTypeReponseFormatError
}

