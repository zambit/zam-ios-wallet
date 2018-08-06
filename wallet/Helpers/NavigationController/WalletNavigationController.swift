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

    init(navigationController: UINavigationController) {
        self.controller = navigationController
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

        hideBackButton(for: viewController)

        if controller.viewControllers.count > 2 {
            addBackButton(for: viewController)
        }
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
        let newHierarchy = [root, viewController, currentViewController]
        controller.setViewControllers(newHierarchy, animated: false)
        controller.popViewController(animated: true)

        viewController.walletNavigationController = self

        hideBackButton(for: viewController)
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
