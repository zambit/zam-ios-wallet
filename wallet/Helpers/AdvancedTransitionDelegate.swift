//
//  AdvancedTransitionDelegate.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

protocol AdvancedTransitionDelegate: class {

    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String: Any])
}
