//
//  NewPasswordViewController.swift
//  wallet
//
//  Created by  me on 09/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class NewPasswordViewController : KeyboardViewController {
    
    // events
    var onNewPassword: ((String)->Void)?
    //
    @IBOutlet weak var coolButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // warning copy-paste detected
        coolButton.layer.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        coolButton.layer.cornerRadius = 5
        coolButton.layer.masksToBounds = false
    }
    
    @IBAction func onCoolButton(_ sender: Any) {
        onNewPassword?("get me from textfields and cmp first")
    }
    
}
