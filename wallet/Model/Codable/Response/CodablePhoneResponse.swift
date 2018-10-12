//
//  CodablePhoneResponse.swift
//  wallet
//
//  Created by Alexander Ponomarev on 12/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CodablePhoneResponse: Codable {

    let result: Bool
    let data: CodablePhone

    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }

    struct CodablePhone: Codable {
        let phone: String

        private enum CodingKeys: String, CodingKey {
            case phone
        }
    }
}
