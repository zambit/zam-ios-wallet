//
//  URLComponents+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension URLComponents {

    mutating func addQueryItems(_ queryItems: [URLQueryItem]) {
        if self.queryItems == nil {
            self.queryItems = []
        }

        self.queryItems?.append(queryItems)
    }
}
