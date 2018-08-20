//
//  WalletNavigation.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Wrapper on NavigationController that provides special style and custom behaviour.
 */
class WalletNavigationController {

    enum PushOrder {
        case forward
        case back
    }

    var customTransitionCoordinator: TransitionCoordinator? {
        didSet {
            self.controller.delegate = customTransitionCoordinator
            self.controller.transitioningDelegate = customTransitionCoordinator
        }
    }

    private(set) var controller: UINavigationController

    private var childTabBar: WalletTabBarController?
    weak var parentTabBar: WalletTabBarController?

    init(navigationController: UINavigationController) {
        self.controller = navigationController

        (navigationController.viewControllers.first as? WalletViewController)?.walletNavigationController = self
        setupStyle(for: self.controller)
    }

    private func setupStyle(for navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        navigationController.navigationItem.hidesBackButton = true
    }

    func push(viewController: WalletViewController) {
        controller.pushViewController(viewController, animated: true)
        viewController.walletNavigationController = self
        viewController.walletTabBar = parentTabBar

        hideBackButton(for: viewController)

        if controller.tabBarController != nil || controller.viewControllers.count > 2 {
            addBackButton(for: viewController)
        }
    }

    func pushFromRootForward(tabBarController: WalletTabBarController) {
        controller.pushViewController(tabBarController.controller, animated: true)
        controller.isNavigationBarHidden = true

        childTabBar = tabBarController
        childTabBar?.navigationController = self
        //tabBar?.home?.walletNavigationController = self

        guard
            controller.viewControllers.count > 1,
            let root = controller.viewControllers.first else {
            return
        }

        let newHierarchy = [root, tabBarController.controller]
        controller.setViewControllers(newHierarchy, animated: false)
    }

    func pushFromRootForward(viewController: WalletViewController) {
        guard controller.viewControllers.count > 1 else {
            push(viewController: viewController)
            return
        }

        controller.pushViewController(viewController, animated: true)
        viewController.walletNavigationController = self

        hideBackButton(for: viewController)

        guard let root = controller.viewControllers.first else {
            return
        }

        childTabBar = nil
        let newHierarchy = [root, viewController]
        controller.setViewControllers(newHierarchy, animated: false)
    }

    func pushFromRootBack(viewController: WalletViewController) {
        guard controller.viewControllers.count > 1 else {
            push(viewController: viewController)
            return
        }

        guard let currentViewController = controller.viewControllers.last,
            let root = controller.viewControllers.first else {
            return
        }

        childTabBar = nil
        let newHierarchy = [root, viewController, currentViewController]
        controller.setViewControllers(newHierarchy, animated: false)
        controller.popViewController(animated: true)

        viewController.walletNavigationController = self

        hideBackButton(for: viewController)
    }

    func presentWithNavBar(viewController: WalletViewController) {
        let navigationController = WalletNavigationController(navigationController: UINavigationController(rootViewController: viewController))
        navigationController.controller.modalPresentationStyle = .overFullScreen

        controller.present(navigationController.controller, animated: true, completion: nil)
        viewController.walletNavigationController = self
        viewController.walletTabBar = parentTabBar

        hideBackButton(for: viewController)
    }

    func present(viewController: WalletViewController) {
        controller.present(viewController, animated: false, completion: nil)
        viewController.walletNavigationController = self
        viewController.walletTabBar = parentTabBar

        hideBackButton(for: viewController)
    }

    func addBackButton(for viewController: WalletViewController, target: Any?, action: Selector) {
        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: target,
            action: action
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    func addBackButton(for viewController: WalletViewController) {
        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: self,
            action: #selector(backBarButtonItemTap(_:))
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    func hideBackButton(for viewController: WalletViewController) {
        let backEmptyButton = UIBarButtonItem(title: "",
                                              style: .plain,
                                              target: controller,
                                              action: nil)
        viewController.navigationItem.leftBarButtonItem = backEmptyButton
    }

    func addRightBarItemButton(for viewController: WalletViewController, title: String, target: Any?, action: Selector) {
        let exitButton = UIBarButtonItem(title: title,
                                         style: .plain,
                                         target: target,
                                         action: action)

        exitButton.tintColor = .skyBlue
        viewController.navigationItem.rightBarButtonItem = exitButton
    }

    @objc
    private func backBarButtonItemTap(_ sender: UIBarButtonItem) {
        self.controller.popViewController(animated: true)
    }

}
