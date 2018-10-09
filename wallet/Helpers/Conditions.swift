//
//  Condition.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

struct Conditions {

    enum Password: String {
        case passwordFieldsMatch = "Confirmation should match the password"
        case passwordMatchesSymbolsCount = "Password should have at least 6 symbols"
    }

    enum Phone: String {
        case phoneLengthMatchesMask = "Phone number should be longer"
        case phoneNumberHaveValidCode = "Phone number should have valid country code"
    }

    enum VerificationCode: String {
        case codeLengthMatchesMask = "Verification code should be 6 symbols at length"
    }
}
