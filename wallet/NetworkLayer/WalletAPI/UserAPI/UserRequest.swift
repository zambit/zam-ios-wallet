//
//  UserRequest.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum UserRequest: Request {

    case userInfo(token: String, coin: String?)

    // Transactions
    case sendTransaction(token: String, walletId: String, recipient: String, amount: Decimal)
    case getTransactions(token: String, coin: String?, walletId: String?, recipient: String?, direction: String?, fromTime: String?, untilTime: String?, page: String?, count: Int?, group: String)
    case getTransactionInfo(token: String, transactionId: String)

    // Wallets
    case createWallet(token: String, coin: String, walletName: String?)
    case getUserWallets(token: String, coin: String?, walletId: String?, page: String?, count: Int?)
    case getUserWalletInfo(token: String, walletId: String)

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

        case let .getTransactions(token: _, coin: coin, walletId: id, recipient: recipient, direction: direction, fromTime: from, untilTime: until, page: page, count: count, group: group):
            let dict = [
                "coin": coin,
                "wallet_id": id,
                "recipient": recipient,
                "direction": direction,
                "from_time": from,
                "until_time": until,
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
        }
    }

    var headers: [String : Any]? {
        switch self {
        case .userInfo(token: let token, coin: _):
            return ["Authorization": "Bearer \(token)"]
        case .sendTransaction(token: let token, walletId: _, recipient: _, amount: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTransactions(token: let token, coin: _, walletId: _, recipient: _, direction: _, fromTime: _, untilTime: _, page: _, count: _, group: _):
            return ["Authorization": "Bearer \(token)"]
        case .getTransactionInfo(token: let token, transactionId: _):
            return ["Authorization": "Bearer \(token)"]
        case .createWallet(token: let token, coin: _, walletName: _):
            return ["Authorization": "Bearer \(token)"]
        case .getUserWallets(token: let token, coin: _, walletId: _, page: _, count: _):
            return ["Authorization": "Bearer \(token)"]
        case .getUserWalletInfo(token: let token, walletId: _):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
