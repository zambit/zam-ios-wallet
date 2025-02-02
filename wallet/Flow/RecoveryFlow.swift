//
//  RecoveryFlow.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class RecoveryFlow: ScreenFlow {

    unowned var navigationController: WalletNavigationController

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController.custom.push(viewController: enterPhoneNumberScreen)
    }

    private var enterPhoneNumberScreen: EnterPhoneNumberViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneNumberViewController", storyboardName: "Recovery")

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

            strongSelf.navigationController.custom.push(viewController: target)
        }

        vc.onContinue = onContinue
        vc.recoveryAPI = RecoveryAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
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
            phone, recoveryToken in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.createNewPasswordScreen
            target.prepare(phone: phone, token: recoveryToken)

            strongSelf.navigationController.custom.push(viewController: target)
        }

        vc.onContinue = onContinue
        vc.verifyAPI = RecoveryAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
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
            phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.secondLoginFlow
            target.prepare(phone: phone)
            target.begin()
        }
        vc.onContinue = onContinue
        vc.recoveryAPI = RecoveryAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.title = "New password"
        vc.flow = self
        return vc
    }

    private var secondLoginFlow: SecondEnterLoginFlow {
        let flow = SecondEnterLoginFlow(navigationController: navigationController)
        return flow
    }
}
