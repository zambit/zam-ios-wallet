//
//  UserRequest.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum UserRequest: Request {

    // TODO: COMPLETE

    case userInfo(token: String)
    case createUserKYCRequest(token: String, userId: String, name: String, surname: String, birthdate: String, country: String, address: String, email: String, status: String)
    case userKYCRequestInfo(token: String)
    case userRefferals(token: String)
    case createWalletForCoin(token: String, coin: String, walletName: String)
    case allUserWallets(token: String, coin: String, walletId: String, page: String, count: Int)

    var path: String {
        switch self {
        case .userInfo:
            return "user/me"
        case .createUserKYCRequest, .userKYCRequestInfo:
            return "user/me/verify"
        case .userRefferals:
            return "user/me/refferals"
        case .createWalletForCoin, .allUserWallets:
            return "user/me/wallets"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        case .createUserKYCRequest:
            return .post
        case .userKYCRequestInfo:
            return .get
        case .userRefferals:
            return .get
        case .createWalletForCoin:
            return .post
        case .allUserWallets:
            return .get
        }
    }

    var parameters: RequestParams? {
        return nil
    }

    var headers: [String : Any]? {
        return nil
    }
}
