//
//  SendMoneyViewController.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyViewController: UIViewController {

    @IBOutlet var sendMoneyComponent: SendMoneyComponent?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        //setupDefaultStyle()
    }
}
