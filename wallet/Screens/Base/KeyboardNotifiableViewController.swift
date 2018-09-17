//
//  KeyboardNotifiableViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class KeyboardNotifiableViewController: UIViewController {

    var isKeyboardShown: Bool {
        return _isKeyboardShown
    }

    private var _isKeyboardShown: Bool = false
    private var _dismissHandlerAction: () -> Void = {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(_:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(_:)),
                                               name: NSNotification.Name.UIKeyboardDidHide,
                                               object: nil)
    }

    func dismissKeyboard(completion handler: @escaping () -> Void) {
        self._dismissHandlerAction = handler

        guard isKeyboardShown else {
            return handler()
        }

        self.dismissKeyboard()
    }

    @objc
    private func keyboardDidShow(_ sender: NSNotification) {
        _isKeyboardShown = true
    }

    @objc
    private func keyboardDidHide(_ sender: NSNotification) {
        _isKeyboardShown = false
        _dismissHandlerAction()

        self._dismissHandlerAction = {}
    }
}
