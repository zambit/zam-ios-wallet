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

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(enterPinScreen, animated: true)
    }

    private var enterPinScreen: CreatePinViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "CreatePinViewController", storyboardName: "Pin")

        guard let vc = _vc as? CreatePinViewController else {
            fatalError()
        }

        vc.flow = self
        return vc
    }

    private var enterPhoneLoginPasswordScreen: EnterPhoneLoginPasswordViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneLoginPasswordViewController", storyboardName: "Login")

        guard let vc = _vc as? EnterPhoneLoginPasswordViewController else {
            fatalError()
        }

        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            self?.userFlow?.begin()
        }

        let onRecovery: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.recoveryFlow?.begin()
        }
        vc.onContinue = onContinue
        vc.onRecovery = onRecovery
        vc.authAPI = AuthAPI(provider: AuthProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = WalletUserDefaultsManager()
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

    private var recoveryFlow: RecoveryFlow? {
        guard let navController = navigationController else {
            print("Navigation controller not found")
            return nil
        }

        let flow = RecoveryFlow(navigationController: navController)
        return flow
    }
}
