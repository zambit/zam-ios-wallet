//
//  UserViewController.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: FlowViewController {

    var userManager: WalletUserDefaultsManager?

    @IBOutlet var tokenLabel: UILabel?
    @IBOutlet var phoneNumberLabel: UILabel?

    private var authToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let phone = userManager?.getPhoneNumber() {
            phoneNumberLabel?.text = phone
        } else {
            phoneNumberLabel?.text = "Phone cant extract from UserDefaults"
        }

        tokenLabel?.text = authToken

        setupDefaultStyle()
    }

    func prepare(authToken: String) {
        self.authToken = authToken
        print("Auth token: \(authToken)")
    }

}
