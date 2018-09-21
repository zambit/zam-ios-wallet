//
//  AvoidingViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 UIViewController providing avoiding keyboard behavior by changing fastenBottomConstraint constant value according keyboard fame during its animation.
 */
class AvoidingViewController: FlowViewController, WalletNavigable {

    var appearingAnimationBlock: () -> Void = {}
    var disappearingAnimationBlock: () -> Void = {}

    var fastenInitialOffset: CGFloat {
        return 24
    }

    @IBOutlet var fastenBottomConstraint: NSLayoutConstraint?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyKeyboard(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @objc
    func notifyKeyboard(_ notification: NSNotification) {

        guard let userInfoNotification = notification.userInfo else {
            return
        }

        let endFrame = (userInfoNotification[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let duration: TimeInterval = (userInfoNotification[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfoNotification[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        let tabBarOffset: CGFloat = tabBarController == nil ? 0 : -49

        UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
            if let keyboardView = endFrame, keyboardView.origin.y < UIScreen.main.bounds.size.height {
                self.appearingAnimationBlock()
                self.fastenBottomConstraint?.constant = UIDevice.current.isExtra ? keyboardView.size.height + self.fastenInitialOffset - 34 + tabBarOffset : keyboardView.size.height + self.fastenInitialOffset + tabBarOffset
            } else {
                self.disappearingAnimationBlock()
                self.fastenBottomConstraint?.constant = self.fastenInitialOffset
            }
            self.view.layoutIfNeeded()

        }, completion: nil)
    }
}

