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

    unowned var migratingNavigationController: WalletNavigationController

    init(migratingNavigationController: WalletNavigationController) {
        self.migratingNavigationController = migratingNavigationController
    }

    func begin() {
        self.migratingNavigationController.custom.push(viewController: enterPhoneLoginPasswordScreen)
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
        vc.onContinue = onContinue
        vc.onRecovery = onRecovery
        vc.telephonyProvider = UserTelephonyInfoProvider()
        vc.authAPI = AuthAPI(provider: AuthProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.flow = self
        return vc
    }

    private var createPinFlow: CreatePinFlow? {
        let flow = CreatePinFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var userFlow: MainFlow? {
        let flow = MainFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }

    private var recoveryFlow: RecoveryFlow? {
        let flow = RecoveryFlow(migratingNavigationController: migratingNavigationController)
        return flow
    }
}
