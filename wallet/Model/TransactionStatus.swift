//
//  TransactionStatus.swift
//  wallet
//
//  Created by Alexander Ponomarev on 24/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum TransactionStatus: String {
    case waiting
    case pending
    case awaitingRecipient = "awaiting_recipient"
    case awaitingConfirmation = "awaiting_confirmation"
    case done
    case success
    case cancelled
    case decline
    case failed

    var formatted: String {
        switch self {
        case .pending:
            return "Pending"
        case .awaitingRecipient:
            return "Awaiting recipient"
        case .awaitingConfirmation:
            return "Awaiting confirmation"
        case .done:
            return "Done"
        case .cancelled:
            return "Cancelled"
        case .waiting:
            return "Waiting"
        case .failed:
            return "Failed"
        case .decline:
            return "Declined"
        case .success:
            return "Done"
        }
    }
}
