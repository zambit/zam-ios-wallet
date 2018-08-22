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

    weak var navigationController: WalletNavigationController?

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.push(viewController: enterPinScreen, animated: false)
    }

    func begin(animated: Bool) {
        self.navigationController?.push(viewController: enterPinScreen, animated: animated)
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
            self?.userFlow?.begin()
        }

        let onExit: () -> Void = {
            [weak self] in
            self?.onboardingFlow?.begin()
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
        vc.authAPI = AuthAPI(provider: AuthProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.biometricAuth = BiometricIDAuth()
        vc.prepare(phone: phone)
        vc.flow = self
        return vc
    }

    private var userFlow: HomeFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = HomeFlow(navigationController: navController)
        return flow
    }

    private var onboardingFlow: OnboardingFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = OnboardingFlow(navigationController: navController)
        return flow
    }

    private var secondLoginFlow: SecondEnterLoginFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = SecondEnterLoginFlow(navigationController: navController)
        return flow
    }
}
