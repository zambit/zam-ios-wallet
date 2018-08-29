//
//  DirectionType.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum DirectionType: String {
    case incoming
    case outgoing

    init?(formatted: String) {
        switch formatted {
        case "Sent":
            self = .outgoing
        case "Received":
            self = .incoming
        default:
            return nil
        }
    }

    var formatted: String {
        switch self {
        case .incoming:
            return "Received"
        case .outgoing:
            return "Sent"
        }
    }
}
