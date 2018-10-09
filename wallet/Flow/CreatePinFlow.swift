//
//  CreatePinFlow.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class CreatePinFlow: ScreenFlow {

    unowned var navigationController: WalletNavigationController

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController.custom.push(viewController: createPinScreen)
    }

    private var createPinScreen: CreatePinViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "CreatePinViewController", storyboardName: "Pin")

        guard let vc = _vc as? CreatePinViewController else {
            fatalError()
        }

        let onContinue: () -> Void = {
            [weak self] in
            self?.userFlow?.begin()
        }

        let onSkip: () -> Void = {
            [weak self] in
            self?.userFlow?.begin()
        }

        vc.onContinue = onContinue
        vc.onSkip = onSkip
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.flow = self
        return vc
    }

    private var userFlow: MainFlow? {
        let flow = MainFlow(navigationController: navigationController)
        return flow
    }
}

