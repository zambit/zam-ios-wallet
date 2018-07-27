//
//  CreateNewPasswordViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreateNewPasswordViewController: UIViewController {

    var signupAPI: SignupAPI?

    var onContinue: ((_ authToken: String) -> Void)?

    private var phone: String?
    private var signupToken: String?

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var newPasswordFormView: NewPasswordFormView?
    @IBOutlet var continueButton: LargeIconButton?

    @IBOutlet var continueButtonBottomConstraint: NSLayoutConstraint?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(notifyKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultStyle()
        hideKeyboardOnTap()

        setupViewControllerStyle()
    }

    private func setupViewControllerStyle() {
        largeTitleLabel?.textColor = .white

        continueButton?.setImage(#imageLiteral(resourceName: "icArrowRight"), for: .normal)
        continueButton?.addTarget(self, action: #selector(continueButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
    }

    func prepare(phone: String, signupToken: String) {
        self.phone = phone
        self.signupToken = signupToken
    }

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard
            let phone = self.phone,
            let password = newPasswordFormView?.password,
            let confirmation = newPasswordFormView?.confirmation,
            let token = self.signupToken else {
            return
        }

        signupAPI?.providePassword(password, confirmation: confirmation, for: phone, signUpToken: token).done {
            [weak self]
            authToken in

            print(authToken)
        }.catch { error in
            print(error)
        }
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
        if endFrame!.origin.y >= UIScreen.main.bounds.size.height {
            self.continueButtonBottomConstraint?.constant = 24.0
        } else {
            self.continueButtonBottomConstraint?.constant = endFrame?.size.height ?? 24
        }

        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}
