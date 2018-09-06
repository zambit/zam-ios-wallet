//
//  WalletTransactionData.swift
//  wallet
//
//  Created by Александр Пономарев on 19.08.2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum TransactionParticipant {
    case sender(String)
    case recipient(String)
    case none

    var formatted: String {
        var data: String

        switch self {
        case .sender(let sender):
            data = sender
        case .recipient(let recipient):
            data = recipient
        case .none:
            return "-"
        }

        let phone = PhoneNumberFormatter(data)

        if phone.isValid {
            return phone.formatted
        } else {
            return data
        }
    }
}

struct TransactionData {

    let id: String
    let direction: DirectionType
    let status: TransactionStatus
    let coin: CoinType
    let participant: TransactionParticipant
    let amount: BalanceData

    init(codable: CodableTransaction) throws {
        self.id = codable.id

        guard let direction = DirectionType(rawValue: codable.direction) else {
            throw TransactionDataError.directionTypeResponseFormatError
        }
        self.direction = direction

        guard let status = TransactionStatus(rawValue: codable.status) else {
            throw TransactionDataError.transactionStatusResponseFormatError
        }
        self.status = status

        guard let coin = CoinType(rawValue: codable.coin) else {
            throw TransactionDataError.coinTypeReponseFormatError
        }
        self.coin = coin

        if let recipient = codable.recipient {
            self.participant = .recipient(recipient)
        } else if let sender = codable.sender {
            self.participant = .sender(sender)
        } else {
            self.participant = .none
        }

        do {
            let amount = try BalanceData(coin: coin, codable: codable.amount)
            self.amount = amount
        } catch {
            throw TransactionDataError.amountFormatError
        }
    }

    var formattedAmount: BalanceData {
        switch direction {
        case .incoming:
            return amount
        case .outgoing:
            return amount.negative
        }
    }
}

enum TransactionDataError: Error {
    case coinTypeReponseFormatError
    case amountFormatError
    case transactionStatusResponseFormatError
    case directionTypeResponseFormatError
}
