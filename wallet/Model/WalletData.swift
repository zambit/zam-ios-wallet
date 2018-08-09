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

    let name: String
    let coin: CoinType
    let balance: Float

    init(codable: CodableWallet) throws {
        self.name = codable.name

        guard let coinType = CoinType(rawValue: codable.coin) else {
            throw WalletDataError.coinTypeReponseFormatError
        }

        self.coin = coinType

        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: codable.balance)
        self.balance = number?.floatValue ?? 0.0
    }
    
}

enum WalletDataError: Error {
    case coinTypeReponseFormatError
}

