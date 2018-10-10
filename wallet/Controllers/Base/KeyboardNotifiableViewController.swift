//
//  KeyboardNotifiableViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 17/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class KeyboardNotifiableViewController: UIViewController {

    var keyboardHeight: CGFloat? {
        return _keyboardHeight
    }

    var isKeyboardShown: Bool {
        return _isKeyboardShown
    }

    var isKeyboardHidesOnTap: Bool = false {
        willSet {
            guard isKeyboardHidesOnTap != newValue else {
                return
            }

            switch newValue {
            case true:
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(UIViewController.dismissKeyboard))

                self.view.addGestureRecognizer(tap)
                self.tapGestureRecognizer = tap
            case false:
                self.view.removeGestureRecognizer(tapGestureRecognizer!)
                self.tapGestureRecognizer = nil
            }
        }
    }

    private var tapGestureRecognizer: UITapGestureRecognizer?

    private var _keyboardHeight: CGFloat?
    private var _isKeyboardShown: Bool = false
    private var _dismissHandlerAction: () -> Void = {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    func dismissKeyboard(completion handler: @escaping () -> Void) {
        self._dismissHandlerAction = handler

        guard isKeyboardShown else {
            self._dismissHandlerAction()
            self._dismissHandlerAction = {}
            return
        }

        self.dismissKeyboard()
    }
    

    @objc
    private func keyboardDidShow(_ sender: NSNotification) {
        _isKeyboardShown = true

        if let keyboardValue = sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardFrame = view.convert(keyboardValue.cgRectValue, from: nil)
            _keyboardHeight = keyboardFrame.height
        }
    }

    @objc
    private func keyboardDidHide(_ sender: NSNotification) {
        _isKeyboardShown = false
        _keyboardHeight = nil
        _dismissHandlerAction()

        self._dismissHandlerAction = {}
    }
}
