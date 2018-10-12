//
//  CodableWalletResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableWalletResponse: Codable {

    let result: Bool
    let data: WalletPage

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct WalletPage: Codable {
        let wallet: CodableWallet

        private enum CodingKeys: String, CodingKey {
            case wallet
        }
    }
}
