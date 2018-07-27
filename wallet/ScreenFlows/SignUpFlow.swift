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
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneNumberViewController", storyboardName: "Registration")

        guard let vc = _vc as? EnterPhoneNumberViewController else {
            fatalError()
        }

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
        vc.signupAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        return vc
    }()

    lazy var verifyPhoneNumberWithSmsScreen: VerifyPhoneNumberWithSmsViewController = {
        let _vc = ControllerHelper.instantiateViewController(identifier: "VerifyPhoneNumberWithSmsViewController", storyboardName: "Registration")

        guard let vc = _vc as? VerifyPhoneNumberWithSmsViewController else {
            fatalError()
        }

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
        vc.signupAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        return vc
    }()

    lazy var createNewPasswordScreen: CreateNewPasswordViewController = {
        let _vc = ControllerHelper.instantiateViewController(identifier: "CreateNewPasswordViewController", storyboardName: "Registration")

        guard let vc = _vc as? CreateNewPasswordViewController else {
            fatalError()
        }

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
        vc.onContinue = onContinue
        vc.signupAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        return vc
    }()

    lazy var userScreen: UserViewController = {
        let vc = UserViewController()
        return vc
    }()
}
