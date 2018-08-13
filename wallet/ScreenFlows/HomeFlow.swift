//
//  UserFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class HomeFlow: ScreenFlow {

    weak var navigationController: WalletNavigationController?

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushFromRootForward(tabBarController: walletTabBar)
    }

    private var walletTabBar: WalletTabBarController {
        let tabBar = WalletTabBarController(home: homeScreen,
                                            transactions: UIViewController(),
                                            zam: UIViewController(),
                                            contacts: UIViewController(),
                                            more: UIViewController())

        return tabBar
    }

    private var homeScreen: HomeViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "HomeViewController", storyboardName: "Main")

        guard let vc = _vc as? HomeViewController else {
            fatalError()
        }

        vc.embededViewController = walletsScreen
        vc.flow = self
        return vc
    }

    private var walletsScreen: WalletsViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "WalletsViewController", storyboardName: "Main")

        guard let vc = _vc as? WalletsViewController else {
            fatalError()
        }

        vc.userManager = UserDataManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
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
