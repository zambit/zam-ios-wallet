//
//  EnterPinFlow.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class EnterPinFlow: ScreenFlow {

    private var phone: String?

    unowned var migratingNavigationController: WalletNavigationController

    init(migratingNavigationController: WalletNavigationController) {
        self.migratingNavigationController = migratingNavigationController
    }

    func begin() {
        self.migratingNavigationController.custom.pushFromRoot(viewController: enterPinScreen, direction: .forward)
    }

    func begin(animated: Bool) {
        self.migratingNavigationController.custom.pushFromRoot(viewController: enterPinScreen, animated: animated, direction: .forward)
    }

    func prepare(phone: String) {
        self.phone = phone
    }

    private var enterPinScreen: EnterPinViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPinViewController", storyboardName: "Pin")

        guard let vc = _vc as? EnterPinViewController else {
            fatalError()
        }

        guard let phone = phone else {
            fatalError("Phone wasn't provided")
        }

        let onContinue: () -> Void = {
            [weak self] in
            self?.userFlow.begin()
        }

        let onExit: () -> Void = {
            [weak self] in
            self?.onboardingFlow.begin()
        }

        let onLoginForm: (String) -> Void = {
            [weak self]
            phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.secondLoginFlow
            target?.prepare(phone: phone)
            target?.begin()
        }

        vc.onContinue = onContinue
        vc.onExit = onExit
        vc.onLoginForm = onLoginForm
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.authAPI = AuthAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.biometricAuth = BiometricIDAuth()
        vc.prepare(phone: phone)
        vc.flow = self
        return vc
    }

    private var userFlow: MainFlow {
        let flow = MainFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var onboardingFlow: OnboardingFlow {
        let flow = OnboardingFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var secondLoginFlow: SecondEnterLoginFlow? {
        let flow = SecondEnterLoginFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }
}
