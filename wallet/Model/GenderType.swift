//
//  GenderType.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum GenderType: String, Equatable {
    case male
    case female
    case undefined

    var formatted: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .undefined:
            return "Undefined"
        }
    }
}
