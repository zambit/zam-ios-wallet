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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let target = segue.destination as? SMSConfirmationViewController {
            target.topTitle = "Подтвердите восстановление"
        }
    }
    @IBAction func onNextButton(_ sender: Any) {
        self.performSegue(withIdentifier: "to_pwd_sms_confirm", sender: self)
    }
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
