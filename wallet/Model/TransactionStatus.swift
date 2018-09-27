//
//  TransactionStatus.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum TransactionStatus: String, Equatable {
    case waiting
    case decline
    case pending
    case cancel
    case success

    var formatted: String {
        switch self {
        case .pending:
            return "Pending"
        case .cancel:
            return "Cancelled"
        case .waiting:
            return "Waiting"
        case .decline:
            return "Declined"
        case .success:
            return "Done"
        }
    }
}
