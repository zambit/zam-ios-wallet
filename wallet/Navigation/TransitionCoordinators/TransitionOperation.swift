//
//  CustomNavigationOperation.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

enum TransitionOperation {

    case present
    case dismiss
    case push
    case pop
    case idle

    init(operation: UINavigationControllerOperation) {
        switch operation {
        case .pop:
            self = .pop
        case .push:
            self = .push
        case .none:
            self = .idle
        }
    }

    var isNavigationController: Bool {
        switch self {
        case .present, .dismiss:
            return false
        case .push, .pop, .idle:
            return true
        }
    }
}
