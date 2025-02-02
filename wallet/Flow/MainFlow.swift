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

    unowned var navigationController: WalletNavigationController

    init(navigationController: WalletNavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController.custom.pushFromRoot(viewController: walletTabBar, direction: .forward)
    }

    private var walletTabBar: WalletTabBarController {
        let tabbar = WalletTabBarController()

        let homeScreenItemData = WalletTabBarItemData(image: #imageLiteral(resourceName: "briefcase"), type: .normal, title: "Home")
        tabbar.custom.add(viewController: homeScreen, with: homeScreenItemData)

        let transactionsScreenItemData = WalletTabBarItemData(image: #imageLiteral(resourceName: "transactions"), type: .normal, title: "History")
        tabbar.custom.add(viewController: transactionsScreen, with: transactionsScreenItemData)

        let zamScreenItemData = WalletTabBarItemData(image: #imageLiteral(resourceName: "logo"), type: .large, title: nil)
        tabbar.custom.add(item: zamScreenItemData)

        let contactsScreenItemData = WalletTabBarItemData(image: #imageLiteral(resourceName: "users"), type: .normal, title: "Verify")
        tabbar.custom.add(viewController: mainKYCScreen, with: contactsScreenItemData)

        let moreScreenItemData = WalletTabBarItemData(image: #imageLiteral(resourceName: "more"), type: .normal, title: "More")
        tabbar.custom.add(viewController: moreScreen, with: moreScreenItemData)

        return tabbar
    }

    // MARK: - MoreTabBarItem

    private var moreScreen: MoreViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "MoreViewController", storyboardName: "More")

        guard let vc = _vc as? MoreViewController else {
            fatalError()
        }

        let onExit: () -> Void = {
            [weak self] in
            self?.onboardingFlow.begin()
        }
        
        vc.onExit = onExit
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.authAPI = AuthAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var onboardingFlow: OnboardingFlow {
        let flow = OnboardingFlow(navigationController: navigationController)
        return flow
    }

    // MARK: - KYCTabBarItem

    private var mainKYCScreen: KYCMainScreenViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCMainScreenViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCMainScreenViewController else {
            fatalError()
        }

        let onKyc0: (KYCPersonalInfo?) -> Void = {
            [weak self]
            data in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.personalInfoScreen

            if let data = data {
                target.prepare(data: data)
            }
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        let onKyc1: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.uploadDocumentsMenuScreen
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.onKyc0 = onKyc0
        vc.onKyc1 = onKyc1
        vc.title = "Identify verification"
        vc.flow = self
        return vc
    }

    private var personalInfoScreen: KYCPersonalInfoViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCPersonalInfoViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCPersonalInfoViewController else {
            fatalError()
        }

        let onSend: (KYCStatus) -> Void = {
            state in

            vc.walletNavigationController?.custom.popBack(nextViewController: {
                next in

                guard let back = next as? KYCMainScreenViewController else {
                    fatalError()
                }

                back.updateKYC0State(state)
            })
        }

        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.onSend = onSend
        vc.title = "KYC0"
        vc.flow = self
        return vc
    }

    private var uploadDocumentsMenuScreen: KYCUploadDocumentsMenuViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCUploadDocumentsMenuViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCUploadDocumentsMenuViewController else {
            fatalError()
        }

        let onFirstDocument: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.uploadPrivateDocumentScreen
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        let onSecondDocument: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.uploadSelfieScreen
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        let onThirdDocument: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.uploadAddressDocumentScreen
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        vc.onFirstDocument = onFirstDocument
        vc.onSecondDocument = onSecondDocument
        vc.onThirdDocument = onThirdDocument
        vc.title = "Upload document KYC1"
        vc.flow = self
        return vc
    }

    private var uploadPrivateDocumentScreen: KYCUploadPrivateDocumentViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCUploadPrivateDocumentViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCUploadPrivateDocumentViewController else {
            fatalError()
        }

        let onSend: (KYCStatus) -> Void = {
            state in

            vc.walletNavigationController?.custom.popBack(nextViewController: {
                next in

                guard let back = next as? KYCUploadDocumentsMenuViewController else {
                    fatalError()
                }

                back.updatePrivateDocumentApprovingState(state)
            })
        }

        vc.onSend = onSend
        vc.title = "01/KYC1"
        vc.flow = self
        return vc
    }

    private var uploadSelfieScreen: KYCUploadSelfieViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCUploadSelfieViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCUploadSelfieViewController else {
            fatalError()
        }

        let onSend: (KYCStatus) -> Void = {
            state in

            vc.walletNavigationController?.custom.popBack(nextViewController: {
                next in

                guard let back = next as? KYCUploadDocumentsMenuViewController  else {
                    fatalError()
                }

                back.updateSelfieApprovingState(state)
            })
        }

        vc.onSend = onSend
        vc.title = "02/KYC1"
        vc.flow = self
        return vc
    }

    private var uploadAddressDocumentScreen: KYCUploadAddressDocumentViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCUploadAddressDocumentViewController", storyboardName: "Verify")

        guard let vc = _vc as? KYCUploadAddressDocumentViewController else {
            fatalError()
        }

        let onSend: (KYCStatus) -> Void = {
            state in

            vc.walletNavigationController?.custom.popBack(nextViewController: {
                next in

                guard let back = next as? KYCUploadDocumentsMenuViewController  else {
                    fatalError()
                }

                back.updateAddressDocumentApprovingState(state)
            })
        }

        vc.onSend = onSend
        vc.title = "03/KYC1"
        vc.flow = self
        return vc
    }

    // MARK: - TransactionsTabBarItem

    private var transactionsScreen: TransactionsHistoryViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionsHistoryViewController", storyboardName: "History")

        guard let vc = _vc as? TransactionsHistoryViewController else {
            fatalError()
        }

        let onFilter: (TransactionsFilterProperties) -> Void = {
            [weak self]
            filterData in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.transactionsFilterScreen
            target.prepare(filterData: filterData)
            vc.walletNavigationController?.custom.push(viewController: target)
        }

        vc.onFilter = onFilter
        vc.contactsManager = UserContactsManager.default
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.title = "Transactions"
        vc.flow = self
        return vc
    }

    private var transactionsFilterScreen: TransactionsHistoryFilterViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionsHistoryFilterViewController", storyboardName: "History")

        guard let vc = _vc as? TransactionsHistoryFilterViewController else {
            fatalError()
        }

        let onDone: (TransactionsFilterProperties) -> Void = {
            filterData in

            vc.walletNavigationController?.custom.popBack(nextViewController: {
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
        let _vc = ControllerHelper.instantiateViewController(identifier: "HomeViewController", storyboardName: "Home")

        guard let vc = _vc as? HomeViewController else {
            fatalError()
        }

        let onSendFromWallet: (Int, [Wallet], FormattedContact?, String) -> Void = {
            [weak self]
            index, wallets, contact, phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.sendMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, recipient: contact, phone: phone)
            target.delegate = vc
            target.advancedTransitionDelegate = vc

            vc.walletNavigationController?.custom.pushAdvancedly(viewController: target)
        }

        let onDepositToWallet: (Int, [Wallet], String) -> Void = {
            [weak self]
            index, wallets, phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.depositMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, phone: phone)
            target.advancedTransitionDelegate = vc

            vc.walletNavigationController?.custom.pushAdvancedly(viewController: target)
        }

        let onWalletDetails: (Int, [Wallet], String) -> Void = {
            [weak self]
            index, wallets, phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.walletDetailsScreen
            target.sendDelegate = vc
            target.advancedTransitionDelegate = vc
            target.prepare(wallets: wallets, currentIndex: index, phone: phone)
            //target.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

            //strongSelf.navigationController.custom.present(viewController: target, animate: false)
            vc.walletNavigationController?.custom.pushAdvancedly(viewController: target)
        }

        vc.onSendFromWallet = onSendFromWallet
        vc.onDepositToWallet = onDepositToWallet
        vc.onWalletDetails = onWalletDetails
        vc.walletsCollectionViewController = walletsScreen
        vc.walletsCollectionViewController?.owner = vc
        vc.contactsManager = UserContactsManager.default
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var walletsScreen: WalletsViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "WalletsViewController", storyboardName: "Home")

        guard let vc = _vc as? WalletsViewController else {
            fatalError()
        }

        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.historyAPI = HistoryAPI(provider: Provider(environment: CryptocompareEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var walletDetailsScreen: WalletDetailsViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "WalletDetailsViewController", storyboardName: "Home")

        guard let vc = _vc as? WalletDetailsViewController else {
            fatalError()
        }

        let onSendFromWallet: (Int, [Wallet], String) -> Void = {
            [weak self]
            index, wallets, phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.sendMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, phone: phone)
            target.delegate = vc
            target.advancedTransitionDelegate = vc

            vc.walletNavigationController?.custom.pushAdvancedly(viewController: target)
        }

        let onDepositToWallet: (Int, [Wallet], String) -> Void = {
            [weak self]
            index, wallets, phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.depositMoneyScreen
            target.prepare(wallets: wallets, currentIndex: index, phone: phone)
            target.advancedTransitionDelegate = vc

            vc.walletNavigationController?.custom.pushAdvancedly(viewController: target)
        }

        let onExit: () -> Void = {
            vc.walletNavigationController?.custom.popViewController(animated: true)
        }

        vc.onSendFromWallet = onSendFromWallet
        vc.onDepositToWallet = onDepositToWallet
        vc.onExit = onExit
        vc.contactsManager = UserContactsManager.default
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.priceAPI = PriceAPI(provider: Provider(environment: CryptocompareEnvironment(), dispatcher: HTTPDispatcher()))
        vc.historyAPI = HistoryAPI(provider: Provider(environment: CryptocompareEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
    }

    private var depositMoneyScreen: DepositMoneyViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "DepositMoneyViewController", storyboardName: "Home")

        guard let vc = _vc as? DepositMoneyViewController else {
            fatalError()
        }

        let onShare: (String) -> Void = {
            address in

            let activityViewController = UIActivityViewController(activityItems: [address], applicationActivities: nil)

            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

            vc.present(activityViewController, animated: true, completion: nil)
        }

        vc.onShare = onShare
        vc.title = "Deposit money"
        vc.flow = self
        return vc
    }

    private var sendMoneyScreen: SendMoneyViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "SendMoneyViewController", storyboardName: "Home")

        guard let vc = _vc as? SendMoneyViewController else {
            fatalError()
        }

        let onSend: (SendingData) -> Void = {
            [weak self]
            data in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.transactionDetailScreen
            target.prepare(sendingData: data)
            target.delegate = vc

            strongSelf.navigationController.custom.presentNavigable(viewController: target, animated: false)
        }

        let onQRScanner: () -> Void = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.qrScannerScreen
            target.delegate = vc
            strongSelf.navigationController.custom.presentNavigable(viewController: target, animated: true)
        }

        vc.definesPresentationContext = true
        vc.providesPresentationContextTransitionStyle = true
        vc.onQRScanner = onQRScanner
        vc.onSend = onSend
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.priceAPI = PriceAPI(provider: Provider(environment: CryptocompareEnvironment(), dispatcher: HTTPDispatcher()))
        vc.title = "Send money"
        vc.flow = self
        return vc
    }

    private var transactionDetailScreen: TransactionDetailViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "TransactionDetailViewController", storyboardName: "Home")

        guard let vc = _vc as? TransactionDetailViewController else {
            fatalError()
        }

        let onClose: (WalletNavigable) -> Void = {
            [weak self]
            owner in

            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController.custom.dismissPresentedViewController()
        }

        vc.onClose = onClose
        vc.userManager = UserDefaultsManager(keychainConfiguration: WalletKeychainConfiguration())
        vc.userAPI = UserAPI(provider: Provider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.modalPresentationStyle = .overFullScreen
        vc.flow = self
        return vc
    }

    private var qrScannerScreen: QRCodeScannerViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "QRCodeScannerViewController", storyboardName: "Home")

        guard let vc = _vc as? QRCodeScannerViewController else {
            fatalError()
        }

        let onClose: (WalletNavigable) -> Void = {
            [weak self]
            owner in

            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController.custom.dismissPresentedViewController()
        }

        vc.modalPresentationStyle = .custom
        vc.onClose = onClose
        vc.flow = self
        return vc
    }
}
