//
//  FiatType.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum FiatType: String, Equatable {
    
    case usd
    case eur

    var name: String {
        switch self {
        case .usd:
            return "Dollar"
        case .eur:
            return "Euro"
        }
    }

    var short: String {
        switch self {
        case .usd:
            return "USD"
        case .eur:
            return "EUR"
        }
    }

    static var standard: FiatType {
        return .usd
    }
}
