//
//  CodableUserInfoResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableUserInfoResponse: Codable {

    let result: Bool
    let data: CodableUser

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }
}
