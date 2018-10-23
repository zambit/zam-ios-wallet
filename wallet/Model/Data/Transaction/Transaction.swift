//
//  Transaction.swift
//  wallet
//
//  Created by Александр Пономарев on 19.08.2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum TransactionParticipantType: Equatable {

    case sender
    case recipient
    case none
}

struct Transaction: Equatable {

    let id: String
    let direction: DirectionType
    let status: TransactionStatus
    let coin: CoinType
    let participantType: TransactionParticipantType
    let participant: String
    let amount: Balance

    var participantPhoneNumber: PhoneNumber?
    var contact: Contact?

    init(id: String, direction: DirectionType, status: TransactionStatus, coin: CoinType, participantType: TransactionParticipantType, participant: String, amount: Balance) {
        self.id = id
        self.direction = direction
        self.status = status
        self.coin = coin
        self.participantType = participantType
        self.participant = participant
        self.amount = amount
    }

    init(codable: CodableTransaction) throws {
        self.id = codable.id

        guard let direction = DirectionType(rawValue: codable.direction) else {
            throw TransactionError.directionTypeInputFormatError
        }
        self.direction = direction

        guard let status = TransactionStatus(rawValue: codable.status) else {
            throw TransactionError.transactionStatusInputFormatError
        }
        self.status = status

        guard let coin = CoinType(rawValue: codable.coin) else {
            throw TransactionError.coinTypeInputFormatError
        }
        self.coin = coin

        if let recipient = codable.recipient {
            self.participantType = .recipient
            self.participant = recipient
        } else if let sender = codable.sender {
            self.participantType = .sender
            self.participant = sender
        } else {
            self.participantType = .none
            self.participant = "-"
        }

        do {
            let amount = try Balance(coin: coin, codable: codable.amount)
            self.amount = amount
        } catch {
            throw TransactionError.amountInputFormatError
        }
    }

    var formattedAmount: Balance {
        switch direction {
        case .incoming:
            return amount
        case .outgoing:
            return amount.negative
        }
    }
}

enum TransactionError: Error {

    case coinTypeInputFormatError
    case amountInputFormatError
    case transactionStatusInputFormatError
    case directionTypeInputFormatError
}
