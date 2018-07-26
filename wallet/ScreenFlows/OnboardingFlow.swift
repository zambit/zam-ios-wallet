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

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(onboardingScreen, animated: true)
    }

    lazy var onboardingScreen: OnboardingViewController = {
        let vc = OnboardingViewController()

        let onLogin: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            guard let navController = strongSelf.navigationController else {
                print("Navigation controller not found")
                return
            }

            let target = LoginFlow(navigationController: navController)
            target.begin()
        }

        let onSignup: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            guard let navController = strongSelf.navigationController else {
                print("Navigation controller not found")
                return
            }

            let target = SignUpFlow(navigationController: navController)
            target.begin()
        }

        vc.onLogin = onLogin
        vc.onSignup = onSignup
        return vc
    }()

}
