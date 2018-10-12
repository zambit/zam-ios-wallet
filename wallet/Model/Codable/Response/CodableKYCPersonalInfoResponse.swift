//
//  CodableKYCPersonalInfoResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodableKYCPersonalInfoResponse: Codable {

    let result: Bool
    let data: CodableKYCPersonalInfo

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }
}
