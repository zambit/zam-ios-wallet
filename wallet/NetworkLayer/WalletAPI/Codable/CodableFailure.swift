//
//  ErrorResponse.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 This struct imitating default json failure response from Wallet Remote API.
 */
struct CodableFailure: Codable {

    let result: Bool
    let message: String?
    let errors: [Error]

    private enum CodingKeys: String, CodingKey {
        case result
        case message
        case errors
    }

    struct Error: Codable {
        let name: String?
        let input: String?
        let message: String

        private enum CodingKeys: String, CodingKey {
            case name
            case input
            case message
        }
    }
}
