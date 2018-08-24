//
//  WalletTransactionData.swift
//  wallet
//
//  Created by Александр Пономарев on 19.08.2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct TransactionData {

    let id: String
    let direction: String
    let status: String
    let coin: CoinType
    let recipient: String
    let amount: BalanceData

    init(codable: CodableTransaction) throws {
        self.id = codable.id
        self.direction = codable.direction
        self.status = codable.status

        guard let coin = CoinType(rawValue: codable.coin) else {
            throw TransactionDataError.coinTypeReponseFormatError
        }
        self.coin = coin
        self.recipient = codable.recipient

        do {
            let amount = try BalanceData(coin: coin, codable: codable.amount)
            self.amount = amount
        } catch {
            throw TransactionDataError.amountFormatError
        }
    }
}

enum TransactionDataError: Error {
    case coinTypeReponseFormatError
    case amountFormatError
}
