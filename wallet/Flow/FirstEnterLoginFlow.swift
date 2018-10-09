//
//  LoginFlow.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class FirstEnterLoginFlow: ScreenFlow {

    unowned var navigationController: WalletNavigationController

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController.custom.push(viewController: enterPhoneLoginPasswordScreen)
    }

    private var enterPhoneLoginPasswordScreen: EnterPhoneLoginPasswordViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneLoginPasswordViewController", storyboardName: "Login")

        guard let vc = _vc as? EnterPhoneLoginPasswordViewController else {
            fatalError()
        }

        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            self?.createPinFlow?.begin()
        }

        let onRecovery: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.recoveryFlow?.begin()
        }

        let onExit: () -> Void = {
            [weak self] in

            self?.onboardingFlow.begin()
        }

        vc.onExit = onExit
        vc.onContinue = onContinue
        vc.onRecovery = onRecovery
        vc.authAPI = AuthAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.flow = self
        return vc
    }

    private var createPinFlow: CreatePinFlow? {
        let flow = CreatePinFlow(navigationController: navigationController)
        return flow
    }

    private var userFlow: MainFlow? {
        let flow = MainFlow(navigationController: navigationController)
        return flow
    }

    private var recoveryFlow: RecoveryFlow? {
        let flow = RecoveryFlow(navigationController: navigationController)
        return flow
    }

    private var onboardingFlow: OnboardingFlow {
        let flow = OnboardingFlow(navigationController: navigationController)
        return flow
    }
}
