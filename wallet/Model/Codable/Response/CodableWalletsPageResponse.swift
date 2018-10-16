//
//  CodableWalletsPageResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableWalletsPageResponse: Codable {

    let result: Bool
    let data: WalletsPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct WalletsPage: Codable {
        let count: Int
        let next: String
        let wallets: [CodableWallet]

        private enum CodingKeys: String, CodingKey {
            case count
            case next
            case wallets
        }
    }
}
