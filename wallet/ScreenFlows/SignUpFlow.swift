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

    unowned var migratingNavigationController: MigratingWalletNavigationController

    init(migratingNavigationController: MigratingWalletNavigationController) {
        self.migratingNavigationController = migratingNavigationController
    }

    func begin() {
        self.migratingNavigationController.custom.push(viewController: enterNewPhoneNumberScreen)
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

            strongSelf.migratingNavigationController.custom.push(viewController: target)
        }

        vc.onContinue = onContinue
        vc.telephonyProvider = UserTelephonyInfoProvider()
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

            strongSelf.migratingNavigationController.custom.push(viewController: target)
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

            self?.createPinFlow.begin()
        }
        vc.onContinue = onContinue
        vc.signupAPI = SignupAPI(provider: SignupProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.title = "Registration"
        vc.flow = self
        return vc
    }

    private var createPinFlow: CreatePinFlow {
        let flow = CreatePinFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var userFlow: MainFlow? {
        let flow = MainFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }
}
