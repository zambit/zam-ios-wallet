//
//  CodableTransactionResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableTransactionResponse: Codable {

    let result: Bool
    let data: Transaction

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct Transaction: Codable {
        let transaction: CodableTransaction

        private enum CodingKeys: String, CodingKey {
            case transaction
        }
    }
}
