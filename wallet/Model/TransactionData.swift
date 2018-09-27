//
//  WalletTransactionData.swift
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

struct TransactionData: Equatable {

    let id: String
    let direction: DirectionType
    let status: TransactionStatus
    let coin: CoinType
    let participantType: TransactionParticipantType
    let participant: String
    let amount: BalanceData

    var participantPhoneNumber: PhoneNumber?
    var contact: ContactData?

    init(id: String, direction: DirectionType, status: TransactionStatus, coin: CoinType, participantType: TransactionParticipantType, participant: String, amount: BalanceData) {
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
