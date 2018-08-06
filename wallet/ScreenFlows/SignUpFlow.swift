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
        self.navigationController?.pushViewController(enterNewPhoneNumberScreen, animated: true)
    }

    private var enterNewPhoneNumberScreen: EnterNewPhoneNumberViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterNewPhoneNumberViewController", storyboardName: "Registration")

        guard let vc = _vc as? EnterNewPhoneNumberViewController else {
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
        vc.flow = self
        return vc
    }

    private var verifyPhoneNumberWithSmsScreen: VerifyPhoneNumberWithSmsViewController {
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
            target.prepare(phone: phone, token: signUpToken)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }

        vc.onContinue = onContinue
        vc.verifyAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var createNewPasswordScreen: CreateNewPasswordViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "CreateNewPasswordViewController", storyboardName: "Registration")

        guard let vc = _vc as? CreateNewPasswordViewController else {
            fatalError()
        }

        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            self?.createPinFlow?.begin()
        }
        vc.onContinue = onContinue
        vc.signupAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = WalletUserDefaultsManager()
        vc.title = "Registration"
        vc.flow = self
        return vc
    }

    private var createPinFlow: CreatePinFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = CreatePinFlow(navigationController: navController)
        return flow
    }

    private var userFlow: UserFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = UserFlow(navigationController: navController)
        return flow
    }
}
