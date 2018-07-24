//
//  ErrorResponse.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableFailure: Codable {

    let result: Bool
    let errors: [Error]

    private enum CodingKeys: String, CodingKey {
        case result
        case errors
    }

    struct Error: Codable {
        let message: String
        let fields: Field

        private enum CodingKeys: String, CodingKey {
            case message
            case fields
        }

        struct Field: Codable {
            let name: String
            let input: String
            let message: String

            private enum CodingKeys: String, CodingKey {
                case name
                case input
                case message
            }
        }
    }
}
