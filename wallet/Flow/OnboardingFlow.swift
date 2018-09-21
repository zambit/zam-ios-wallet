//
//  OnboardingFlow.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 This class provides screen flow for Onboarding Screen. It forks on LoginFlow and SignupFlow.
 */
final class OnboardingFlow: ScreenFlow {

    unowned var migratingNavigationController: WalletNavigationController

    init(migratingNavigationController: WalletNavigationController) {
        self.migratingNavigationController = migratingNavigationController
    }

    func begin() {
        self.migratingNavigationController.custom.pushFromRoot(viewController: onboardingScreen, direction: .back)
    }

    func begin(animated: Bool) {
        self.migratingNavigationController.custom.pushFromRoot(viewController: onboardingScreen, animated: animated, direction: .back)
    }

    private var onboardingScreen: OnboardingViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "OnboardingViewController", storyboardName: "Onboarding")

        guard let vc = _vc as? OnboardingViewController else {
            fatalError()
        }

        let onLogin: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.loginFlow.begin()
        }

        let onSignup: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.signupFlow.begin()
        }

        vc.onLogin = onLogin
        vc.onSignup = onSignup
        vc.flow = self
        return vc
    }

    private var loginFlow: FirstEnterLoginFlow {
        let flow = FirstEnterLoginFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var signupFlow: SignUpFlow {
        let flow = SignUpFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

}
