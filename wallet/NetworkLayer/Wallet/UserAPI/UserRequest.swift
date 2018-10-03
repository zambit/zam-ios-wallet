//
//  UserRequest.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum UserRequest: Request {

    // User
    case userInfo(token: String, coin: String?)

    // Transactions
    case sendTransaction(token: String, walletId: String, recipient: String, amount: Decimal)
    case getTransactions(token: String, coin: String?, walletId: String?, recipient: String?, direction: String?, fromTime: String?,  untilTime: String?, timezone: String?, page: String?, count: Int?, group: String)
    case getTransactionInfo(token: String, transactionId: String)

    // Wallets
    case createWallet(token: String, coin: String, walletName: String?)
    case getUserWallets(token: String, coin: String?, walletId: String?, page: String?, count: Int?)
    case getUserWalletInfo(token: String, walletId: String)

    // KYC Personal
    case sendKYCPersonalInfo(token: String, email: String, firstName: String, lastName: String, birthDate: String, sex: String, country: String, city: String, region: String, street: String, house: String, postalCode: Int)
    case getKYCPersonalInfo(token: String)

    var path: String {
        switch self {
        case .userInfo:
            return "user/me"
        case .createWallet, .getUserWallets:
            return "user/me/wallets"
        case .getUserWalletInfo(token: _, walletId: let id):
            return "user/me/wallets/\(id)"
        case .sendTransaction, .getTransactions:
            return "user/me/txs"
        case .getTransactionInfo(transactionId: let id):
            return "user/me/txs/\(id)"
        case .sendKYCPersonalInfo, .getKYCPersonalInfo:
            return "user/me/personal"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        case .createWallet:
            return .post
        case .getUserWallets:
            return .get
        case .getUserWalletInfo:
            return .get
        case .sendTransaction:
            return .post
        case .getTransactions:
            return .get
        case .getTransactionInfo:
            return .get
        case .sendKYCPersonalInfo:
            return .post
        case .getKYCPersonalInfo:
            return .get
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .userInfo(token: _, coin: coin):
            let dict = [
                "convert": coin
            ]

            return RequestParams.url(dict.unwrapped())
            
        case let .sendTransaction(token: _, walletId: id, recipient: recipient, amount: amount):
            let dict = [
                "wallet_id": id,
                "recipient": recipient,
                "amount": amount.description
                ]

            return RequestParams.body(dict)

        case let .getTransactions(token: _, coin: coin, walletId: id, recipient: recipient, direction: direction, fromTime: from, untilTime: until, timezone: timezone, page: page, count: count, group: group):
            let dict = [
                "coin": coin,
                "wallet_id": id,
                "recipient": recipient,
                "direction": direction,
                "from_time": from,
                "until_time": until,
                "timezone": timezone,
                "page": page,
                "count": String(count),
                "group": group
            ]
            return RequestParams.url(dict.unwrapped())

        case .getTransactionInfo:
            return nil

        case let .createWallet(token: _, coin: coin, walletName: name):
            let dict = [
                "coin": coin,
                "name": name
            ]

            return RequestParams.body(dict.unwrapped())

        case let .getUserWallets(token: _, coin: coin, walletId: id, page: page, count: count):
            let dict = [
                "coin": coin,
                "wallet_id": id,
                "page": page,
                "count": String(count)
            ]
            return RequestParams.url(dict.unwrapped())

        case .getUserWalletInfo:
            return nil

        case let .sendKYCPersonalInfo(token: _, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, sex: sex, country: country, city: city, region: region, street: street, house: house, postalCode: code):
            let dict: [String : Any] = [
                "email": email,
                "first_name": firstName,
                "last_name": lastName,
                "birth_date": birthDate,
                "sex": sex,
                "country": country,
                "city": city,
                "region": region,
                "street": street,
                "house": house,
                "postal_code": code
            ]

            return RequestParams.body(dict)

        case .getKYCPersonalInfo:
            return nil
        }
    }

    var headers: [String : Any]? {
        switch self {
        case .userInfo(token: let token, coin: _):
            return ["Authorization": "Bearer \(token)"]
        case .sendTransaction(token: let token, walletId: _, recipient: _, amount: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTransactions(token: let token, coin: _, walletId: _, recipient: _, direction: _, fromTime: _, untilTime: _, timezone: _, page: _, count: _, group: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTransactionInfo(token: let token, transactionId: _):
            return ["Authorization": "Bearer \(token)"]
        case .createWallet(token: let token, coin: _, walletName: _):
            return ["Authorization": "Bearer \(token)"]
        case .getUserWallets(token: let token, coin: _, walletId: _, page: _, count: _):
            return ["Authorization": "Bearer \(token)"]
        case .getUserWalletInfo(token: let token, walletId: _):
            return ["Authorization": "Bearer \(token)"]
        case .sendKYCPersonalInfo(token: let token, email: _, firstName: _, lastName: _, birthDate: _, sex: _, country: _, city: _, region: _, street: _, house: _, postalCode: _):
            return ["Authorization": "Bearer \(token)"]
        case .getKYCPersonalInfo(token: let token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
