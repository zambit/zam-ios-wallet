//
//  UserFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class UserFlow: ScreenFlow {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.pushViewController(userScreen, animated: true)
    }

    private var userScreen: UserViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "UserViewController", storyboardName: "Main")

        guard let vc = _vc as? UserViewController else {
            fatalError()
        }

        let onExit: () -> Void = {
            [weak self] in

            self?.onboardingFlow?.begin()
        }

        vc.onExit = onExit
        vc.userManager = WalletUserDefaultsManager()
        vc.flow = self
        return vc
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
