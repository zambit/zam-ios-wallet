//
//  AuthViewController.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        self.registrationButton.layer.cornerRadius = 5
        self.registrationButton.layer.masksToBounds = false
    }
    
    @IBAction func onRegistrationButton(_ sender: Any) {
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
    }
}
