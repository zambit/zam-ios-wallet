//
//  SignUpFlow.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class SignUpFlow: ScreenFlow {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(enterPhoneNumberScreen, animated: true)
    }

    lazy var enterPhoneNumberScreen: EnterPhoneNumberViewController = {
        let vc = EnterPhoneNumberViewController()
        let onContinue: (String) -> Void = {
            [weak self]
            phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.verifyPhoneNumberWithSmsScreen
            target.prepare(phone: phone)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }

        vc.onContinue = onContinue
        return vc
    }()

    lazy var verifyPhoneNumberWithSmsScreen: VerifyPhoneNumberWithSmsViewController = {
        let vc = VerifyPhoneNumberWithSmsViewController()
        let onContinue: (String, String) -> Void = {
            [weak self]
            phone, signUpToken in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.createNewPasswordScreen
            target.prepare(phone: phone, signupToken: signUpToken)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }

        vc.onContinue = onContinue
        return vc
    }()

    lazy var createNewPasswordScreen: CreateNewPasswordViewController = {
        let vc = CreateNewPasswordViewController()
        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.userScreen
            target.prepare(authToken: authToken)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }
        return vc
    }()

    lazy var userScreen: UserViewController = {
        let vc = UserViewController()
        return vc
    }()
}
