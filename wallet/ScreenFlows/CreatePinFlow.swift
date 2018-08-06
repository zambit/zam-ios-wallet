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

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(createPinScreen, animated: true)
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
        vc.userManager = WalletUserDefaultsManager(userDefaults: .standard)
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
}

