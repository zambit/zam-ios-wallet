//
//  CodableTokenResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableTokenResponse: Codable {

    let result: Bool
    let data: Token

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct Token: Codable {
        let token: String

        private enum CodingKeys: String, CodingKey {
            case token
        }
    }
}
