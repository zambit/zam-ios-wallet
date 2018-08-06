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
        self.navigationController?.push(viewController: enterPinScreen)
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

        vc.onContinue = onContinue
        vc.onExit = onExit
        vc.userManager = UserDataManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.authAPI = AuthAPI(provider: AuthProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.prepare(phone: phone)
        vc.flow = self
        return vc
    }

    private var userFlow: UserFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = UserFlow(navigationController: navController)
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
