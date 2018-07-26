//
//  CreateNewPasswordViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreateNewPasswordViewController: UIViewController {

    var onContinue: ((_ authToken: String) -> Void)?

    func prepare(phone: String, signupToken: String) {
        print("Phone: \(phone), SignUp token: \(signupToken)")
    }
}
