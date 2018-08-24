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
                                            transactions: transactionsScreen,
                                            zam: UIViewController(),
                                            contacts: UIViewController(),
                                            more: UIViewController())
        return tabBar
    }

    private var transactionsScreen: TransactionsHistoryViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionsHistoryViewController", storyboardName: "Main")

        guard let vc = _vc as? TransactionsHistoryViewController else {
            fatalError()
        }

        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var homeScreen: HomeViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "HomeViewController", storyboardName: "Main")

        guard let vc = _vc as? HomeViewController else {
            fatalError()
        }

        vc.embededViewController = walletsScreen
        vc.embededViewController?.owner = vc
        vc.contactsManager = UserContactsManager(fetchKeys: [.phoneNumber, .fullName, .avatar])
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var walletsScreen: WalletsViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "WalletsViewController", storyboardName: "Main")

        guard let vc = _vc as? WalletsViewController else {
            fatalError()
        }

        let onSendFromWallet: (Int, [WalletData], ContactData?, String, WalletViewController) -> Void = {
            [weak self]
            index, wallets, contact, phone, owner in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.sendMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, recipient: contact, phone: phone)

            owner.walletNavigationController?.push(viewController: target)
        }

        vc.onSendFromWallet = onSendFromWallet
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var sendMoneyScreen: SendMoneyViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "SendMoneyViewController", storyboardName: "Main")

        guard let vc = _vc as? SendMoneyViewController else {
            fatalError()
        }

        let onSend: (SendMoneyData) -> Void = {
            [weak self]
            data in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.transactionDetailScreen
            target.prepare(sendMoneyData: data)

            strongSelf.navigationController?.presentWithNavBar(viewController: target)
        }

        vc.definesPresentationContext = true
        vc.providesPresentationContextTransitionStyle = true
        vc.onSend = onSend
        vc.title = "Send money"
        vc.flow = self
        return vc
    }

    private var transactionDetailScreen: TransactionDetailViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionDetailViewController", storyboardName: "Main")

        guard let vc = _vc as? TransactionDetailViewController else {
            fatalError()
        }

        let onClose: (WalletViewController) -> Void = {
            owner in

            owner.dismiss(animated: true, completion: nil)
        }

        vc.onClose = onClose
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.modalPresentationStyle = .overFullScreen
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
