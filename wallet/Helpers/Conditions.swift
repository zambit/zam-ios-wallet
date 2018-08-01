//
//  PasswordsCondition.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum PasswordsCondition: String {
    case passwordFieldsMatch = "Confirmation should match the password"
    case passwordMatchesSymbolsCount = "Password should have at least 6 symbols"
}

enum PhoneCondition: String {
    case phoneLengthMatchesMask = "Phone number should be longer"
    case phoneNumberHaveValidCode = "Phone number should have valid country code"
}

enum CodeCondition: String {
    case codeLengthMatchesMask = "Verification code should be 6 symbols at length"
}
