//
//  UIViewController+Extensions.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIViewController {

    func setupDefaultStyle() {
        self.view.applyGradient(colors: [.backgroundDarker, .backgroundLighter])
    }

    @objc
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIViewController {

    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}

