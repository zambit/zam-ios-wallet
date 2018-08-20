//
//  WalletTransactionData.swift
//  wallet
//
//  Created by Александр Пономарев on 19.08.2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletTransactionData {

    let id: String
    let direction: String
    let status: String
    let coin: CoinType
    let recipient: String
    let amount: Decimal

    init(codable: CodableTransaction) throws {
        self.id = codable.id
        self.direction = codable.direction
        self.status = codable.status

        guard let coin = CoinType(rawValue: codable.coin) else {
            throw WalletTransactionDataError.coinTypeReponseFormatError
        }
        self.coin = coin
        self.recipient = codable.recipient

        guard let amount = Decimal(string: codable.amount) else {
            throw WalletTransactionDataError.amountFormatError
        }
        self.amount = amount
    }
}

enum WalletTransactionDataError: Error {
    case coinTypeReponseFormatError
    case amountFormatError
}
