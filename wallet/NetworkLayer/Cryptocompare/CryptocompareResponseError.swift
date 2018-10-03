//
//  CryptocompareResponseError.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum CryptocompareResponseError: Error, Equatable {
    case serverFailureResponse(message: String)
    case undefinedServerFailureResponse
}
