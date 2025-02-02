//
//  SecondEnterLoginFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class SecondEnterLoginFlow: ScreenFlow {

    private var phone: String?

    unowned var navigationController: WalletNavigationController

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController.custom.push(viewController: enterLoginPasswordScreen)
    }

    func begin(animated: Bool) {
        self.navigationController.custom.push(viewController: enterLoginPasswordScreen, animated: animated)
    }

    func prepare(phone: String) {
        self.phone = phone
    }

    private var enterLoginPasswordScreen: EnterLoginPasswordViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterLoginPasswordViewController", storyboardName: "Login")

        guard let vc = _vc as? EnterLoginPasswordViewController else {
            fatalError()
        }

        guard let phone = phone else {
            fatalError("Phone wasn't provided")
        }

        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            self?.createPinFlow.begin()
        }

        let onRecovery: (String) -> Void = {
            [weak self]
            phone in

            self?.recoveryFlow.begin()
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
        vc.prepare(phone: phone)
        vc.title = phone
        vc.flow = self
        return vc
    }

    private var createPinFlow: CreatePinFlow {
        let flow = CreatePinFlow(navigationController: navigationController)
        return flow
    }

    private var userFlow: MainFlow {
        let flow = MainFlow(navigationController: navigationController)
        return flow
    }

    private var recoveryFlow: RecoveryFlow {
        let flow = RecoveryFlow(navigationController: navigationController)
        return flow
    }

    private var onboardingFlow: OnboardingFlow {
        let flow = OnboardingFlow(navigationController: navigationController)
        return flow
    }
}

