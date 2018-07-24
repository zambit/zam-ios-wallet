//
//  SignupRequest.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum SignupRequest: Request {
    case start(phone: String, referrerPhone: String?)
    case verify(phone: String, verificationCode: String)
    case finish(phone: String, signupToken: String, password: String, passwordConfirmation: String)

    var path: String {
        switch self {
        case .start:
            return "auth/signup/start"
        case .verify:
            return "auth/signup/verify"
        case .finish:
            return "auth/signup/finish"
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

    var parameters: RequestParams {
        switch self {
        case let .start(phone: phone, referrerPhone: referrerPhone):
            if let rp = referrerPhone {
                return .body([
                    "phone": phone,
                    "referrer_phone": rp
                    ])
            }

            return .body([
                "phone": phone
                ])
        case let .verify(phone: phone, verificationCode: code):

            return .body([
                "phone": phone,
                "verification_code": code
                ])
        case let .finish(phone: phone, signupToken: token, password: password, passwordConfirmation: confirmation):

            return .body([
                "phone": phone,
                "signup_token": token,
                "password": password,
                "password_confirmation": confirmation
                ])
        }
    }

    var headers: [String : Any]? {
        return nil
    }

}
