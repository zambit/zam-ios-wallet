//
//  EnterLoginPasswordViewController.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterLoginPasswordViewController: UIViewController {

    var onContinue: ((_ authToken: String) -> Void)?
    var onExit: (() -> Void)?
    var onRecovery: (() -> Void)?

    func prepare(phone: String) {
        print("Phone: \(phone)")
    }

}


