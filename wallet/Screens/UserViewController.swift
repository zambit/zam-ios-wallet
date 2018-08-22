//
//  UserViewController.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: WalletViewController {

    var authAPI: AuthAPI?
    var userManager: UserDefaultsManager?

    var onExit: (() -> Void)?

    @IBOutlet var tokenLabel: UILabel?
    @IBOutlet var phoneNumberLabel: UILabel?
    @IBOutlet var logoutButton: UIButton?

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

        logoutButton?.addTarget(self, action: #selector(logoutButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func prepare(authToken: String) {
        self.authToken = authToken
        print("Auth token: \(authToken)")
    }

    @objc
    private func logoutButtonTouchUpInsideEvent(_ sender: Any) {
        do {
            try userManager?.clearUserData()
        } catch let error {
            fatalError("Error on clearing user data: \(error)")
        }
        onExit?()
    }

}
