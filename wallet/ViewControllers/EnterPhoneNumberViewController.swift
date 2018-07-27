//
//  EnterPhoneNumberViewController.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class EnterPhoneNumberViewController: UIViewController {

    var signupAPI: SignupAPI?

    var onContinue: ((_ phone: String) -> Void)?
    var onSkip: (() -> Void)?

    private var termsItems: [TermItemData] = []

    @IBOutlet var largeTitleLabel: UILabel?
    @IBOutlet var phoneNumberFormView: PhoneNumberFormView?
    @IBOutlet var continueButton: LargeIconButton?
    @IBOutlet var termsStackView: UIStackView?

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

    @objc
    private func continueButtonTouchUpInsideEvent(_ sender: Any) {
        guard let phone = phoneNumberFormView?.text else {
            return
        }
        print(phone)
        signupAPI?.sendVerificationCode(to: phone).done {
            [weak self] in
            self?.onContinue?(phone)
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

struct TermItemData {
    var text: String
}
