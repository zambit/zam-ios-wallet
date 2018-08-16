//
//  KeyboardBehaviourFollowingViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 UIViewController providing default continue behaviour: "Round @ContinueButton moving with keyboard during it appears"
 */
class KeyboardBehaviorFollowingViewController: WalletViewController {

    var appearingAnimationBlock: () -> Void = {}
    var disappearingAnimationBlock: () -> Void = {}

    var fastenOffset: CGFloat {
        return 24
    }

    @IBOutlet var fastenBottomConstraint: NSLayoutConstraint?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyKeyboard(_:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func notifyKeyboard(_ notification: NSNotification) {

        guard let userInfoNotification = notification.userInfo else {
            return
        }

        let endFrame = (userInfoNotification[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let duration: TimeInterval = (userInfoNotification[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfoNotification[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)


        let tabBarOffset: CGFloat = tabBarController == nil ? 0 : -49

        UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            if let keyboardView = endFrame, keyboardView.origin.y < UIScreen.main.bounds.size.height {
                strongSelf.appearingAnimationBlock()
                strongSelf.fastenBottomConstraint?.constant = UIDevice.current.iPhoneX ? keyboardView.size.height + strongSelf.fastenOffset - 32 + tabBarOffset : keyboardView.size.height + strongSelf.fastenOffset + tabBarOffset
            } else {
                strongSelf.disappearingAnimationBlock()
                strongSelf.fastenBottomConstraint?.constant = strongSelf.fastenOffset
            }
            self?.view.layoutIfNeeded()

            }, completion: nil)
    }

}

