//
//  PasswordRecoveryViewController.swift
//  wallet
//
//  Created by  me on 09/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class PasswordRecoveryViewController : UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // warning copy-paste detected
        nextButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        nextButton.layer.cornerRadius = 5
        nextButton.layer.masksToBounds = false
    }
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
