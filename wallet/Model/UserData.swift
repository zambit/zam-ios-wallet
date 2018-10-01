//
//  UserData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct UserData: Equatable {

    let id: String
    let phone: String
    let status: String
    let registeredAt: Decimal
    let balances: [BalanceData]

    init(codable: CodableUser) throws {
        self.id = codable.id
        self.phone = codable.phone
        self.status = codable.status
        self.registeredAt = codable.registeredAt

        do {
            let totalBalance = try BalanceData(coin: CoinType.standard, codable: codable.wallets.totalBalance)
            self.balances = [totalBalance]
        } catch {
            throw UserDataError.balanceFormatError
        }
    }

    init(id: String, phone: String, status: String, registeredAt: Decimal, balances: [BalanceData]) {
        self.id = id
        self.phone = phone
        self.status = status
        self.registeredAt = registeredAt
        self.balances = balances
    }
}

enum UserDataError: Error {
    case balanceFormatError
}
