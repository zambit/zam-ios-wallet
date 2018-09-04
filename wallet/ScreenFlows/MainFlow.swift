//
//  UserFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class MainFlow: ScreenFlow {

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

    // MARK: - TransactionsTabBarItem

    private var transactionsScreen: TransactionsHistoryViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionsHistoryViewController", storyboardName: "Main")

        guard let vc = _vc as? TransactionsHistoryViewController else {
            fatalError()
        }

        let onFilter: (TransactionsFilterData) -> Void = {
            [weak self]
            filterData in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.transactionsFilterScreen
            target.prepare(filterData: filterData)
            vc.walletNavigationController?.push(viewController: target)
        }

        vc.onFilter = onFilter
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.title = "Transactions"
        vc.flow = self
        return vc
    }

    private var transactionsFilterScreen: TransactionsHistoryFilterViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionsHistoryFilterViewController", storyboardName: "Main")

        guard let vc = _vc as? TransactionsHistoryFilterViewController else {
            fatalError()
        }

        let onDone: (TransactionsFilterData) -> Void = {
            filterData in

            vc.walletNavigationController?.popBack(nextViewController: {
                next in

                guard let target = next as? TransactionsHistoryViewController else {
                    return
                }

                target.update(filterData: filterData)
            })
        }

        vc.onDone = onDone
        vc.title = "Filter"
        vc.flow = self
        return vc
    }

    // MARK: - HomeTabBarItem

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

        let onDepositToWallet: (Int, [WalletData], String, WalletViewController) -> Void = {
            [weak self]
            index, wallets, phone, owner in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.depositMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, phone: phone)

            owner.walletNavigationController?.push(viewController: target)
        }

        vc.onSendFromWallet = onSendFromWallet
        vc.onDepositToWallet = onDepositToWallet
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var depositMoneyScreen: DepositMoneyViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "DepositMoneyViewController", storyboardName: "Main")

        guard let vc = _vc as? DepositMoneyViewController else {
            fatalError()
        }

        let onShare: (String) -> Void = {
            address in

            let activityViewController = UIActivityViewController(activityItems: [address], applicationActivities: nil)

            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

            vc.present(activityViewController, animated: true, completion: nil)
        }

        vc.onShare = onShare
        vc.title = "Deposit money"
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

            strongSelf.navigationController?.present(viewController: target, animate: false)
        }

        let onQRScanner: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.qrScannerScreen
            target.delegate = vc
            strongSelf.navigationController?.present(viewController: target, animate: true)
        }

        vc.definesPresentationContext = true
        vc.providesPresentationContextTransitionStyle = true
        vc.onQRScanner = onQRScanner
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
            [weak self]
            owner in

            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.dismissPresentedViewController()
        }

        vc.onClose = onClose
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: UserProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.modalPresentationStyle = .overFullScreen
        vc.flow = self
        return vc
    }

    private var qrScannerScreen: QRCodeScannerViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "QRCodeScannerViewController", storyboardName: "Main")

        guard let vc = _vc as? QRCodeScannerViewController else {
            fatalError()
        }

        let onClose: (WalletViewController) -> Void = {
            [weak self]
            owner in

            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.dismissPresentedViewController()
        }

        vc.modalPresentationStyle = .custom
        vc.onClose = onClose
        vc.flow = self
        return vc
    }

}
