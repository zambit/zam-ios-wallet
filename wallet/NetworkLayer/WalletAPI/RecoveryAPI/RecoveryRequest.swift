//
//  RecoveryRequest.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum RecoveryRequest: Request {
    case start(phone: String)
    case verify(phone: String, verificationCode: String)
    case finish(phone: String, recoveryToken: String, newPassword: String, newPasswordConfirmation: String)

    var path: String {
        switch self {
        case .start:
            return "auth/recovery/start"
        case .verify:
            return "auth/recovery/verify"
        case .finish:
            return "auth/recovery/finish"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .start:
            return .post
        case .verify:
            return .post
        case .finish:
            return .put
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .start(phone: phone):

            return .body([
                "phone": phone
                ])
        case let .verify(phone: phone, verificationCode: code):

            return .body([
                "phone": phone,
                "verification_code": code
                ])
        case let .finish(phone: phone, recoveryToken: token, newPassword: password, newPasswordConfirmation: confirmation):

            return .body([
                "phone": phone,
                "recovery_token": token,
                "password": password,
                "password_confirmation": confirmation
                ])
        }
    }

    var headers: [String : Any]? {
        return nil
    }
}
