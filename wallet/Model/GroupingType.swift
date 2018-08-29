//
//  GroupingType.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum GroupingType: String {
    case hour
    case day
    case week
    case month
    case year

    init?(formatted: String) {
        self.init(rawValue: formatted.lowercased())
    }

    var formatted: String {
        return self.rawValue.capitalizingFirst
    }
}
