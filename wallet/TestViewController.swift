//
//  TestViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {

    @IBOutlet var recipientComponent: RecipientComponent!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()
    }

    @IBAction func turnLeft() {
        recipientComponent.custom.showPhone()
    }

    @IBAction func turnRight() {
        recipientComponent.custom.showAddress()
    }

}
