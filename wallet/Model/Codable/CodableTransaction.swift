//
//  CodableTransaction.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableTransaction: Codable {

    let id: String
    let direction: String
    let status: String
    let coin: String
    let sender: String?
    let recipient: String?
    let amount: CodableBalance

    private enum CodingKeys: String, CodingKey {
        case id
        case direction
        case status
        case coin
        case sender
        case recipient
        case amount
    }
}
