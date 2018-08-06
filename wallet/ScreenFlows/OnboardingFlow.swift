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

    weak var navigationController: WalletNavigationController?

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushFromRootBack(viewController: onboardingScreen)
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

            guard let _ = strongSelf.navigationController else {
                print("Navigation controller not found")
                return
            }

            strongSelf.loginFlow?.begin()
        }

        let onSignup: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            guard let _ = strongSelf.navigationController else {
                print("Navigation controller not found")
                return
            }

            strongSelf.signupFlow?.begin()
        }

        vc.onLogin = onLogin
        vc.onSignup = onSignup
        vc.flow = self
        return vc
    }

    private var loginFlow: FirstEnterLoginFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = FirstEnterLoginFlow(navigationController: navController)
        return flow
    }

    private var signupFlow: SignUpFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = SignUpFlow(navigationController: navController)
        return flow
    }

}
