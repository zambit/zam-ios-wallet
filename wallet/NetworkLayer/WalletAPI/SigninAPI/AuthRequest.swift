//
//  AuthRequest.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum AuthRequest: Request {

    case signIn(phone: String, password: String)
    case signOut(token: String)
    case checkAuthorized(token: String)
    case confirmUserPhone(token: String, confirmationId: String)
    case createNewUserFromPendingTransaction(token: String, recvInvitationId: String)
    case refreshToken(token: String)

    var path: String {
        switch self {
        case .signIn:
            return "auth/signin"
        case .signOut:
            return "auth/signout"
        case .checkAuthorized:
            return "auth/check"
        case .refreshToken:
            return "auth/refresh_token"
        case let .confirmUserPhone(confirmationId: link):
            return "auth/confirmation/\(link)"
        case let .createNewUserFromPendingTransaction(recvInvitationId: link):
            return "auth/receive/\(link)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signOut:
            return .delete
        case .checkAuthorized:
            return .get
        case .refreshToken:
            return .get
        case .confirmUserPhone:
            return .post
        case .createNewUserFromPendingTransaction:
            return .post
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .signIn(phone: phone, password: password):
            return .body(["phone": phone, "password": password])
        case .signOut:
            return nil
        case .checkAuthorized:
            return nil
        case .refreshToken:
            return nil
        case .confirmUserPhone:
            return nil
        case .createNewUserFromPendingTransaction:
            return nil
        }
    }

    var headers: [String : Any]? {
        switch self {
        case .signIn:
            return nil
        case .signOut(token: let token):
            return ["Authorization": "Bearer \(token)"]
        case .checkAuthorized(token: let token):
            return ["Authorization": "Bearer \(token)"]
        case .refreshToken(token: let token):
            return ["Authorization": "Bearer \(token)"]
        case .confirmUserPhone(token: let token, confirmationId: _):
            return ["Authorization": "Bearer \(token)"]
        case .createNewUserFromPendingTransaction(token: let token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
