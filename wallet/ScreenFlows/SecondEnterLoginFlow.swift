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

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(enterLoginPasswordScreen, animated: true)
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

            self?.createPinFlow?.begin()
        }

        let onRecovery: (String) -> Void = {
            [weak self]
            phone in

            self?.recoveryFlow?.begin()
        }

        let onExit: () -> Void = {
            [weak self] in

            self?.onboardingFlow?.begin()
        }

        vc.onExit = onExit
        vc.onContinue = onContinue
        vc.onRecovery = onRecovery
        vc.authAPI = AuthAPI(provider: AuthProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = WalletUserDefaultsManager()
        vc.prepare(phone: phone)
        vc.title = phone
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

    private var recoveryFlow: RecoveryFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = RecoveryFlow(navigationController: navController)
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
}
