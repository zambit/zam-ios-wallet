//
//  KeyboardViewController.swift
//  wallet
//
//  Created by  me on 09/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class KeyboardViewController : UIViewController {

    private var tapRecognizer: UITapGestureRecognizer!
    
    @objc func onTap() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeGestureRecognizer(tapRecognizer)
        tapRecognizer = nil
    }
}
