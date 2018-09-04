//
//  WalletNavigation.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Hero

/**
 Wrapper on NavigationController that provides special style and custom behaviour.
 */
class WalletNavigationController {

    var transitionCoordinator: NavigationControllerTransitionCoordinator? {
        didSet {
            controller.delegate = transitionCoordinator
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

    func push(viewController: WalletViewController, animated: Bool = true) {
        controller.pushViewController(viewController, animated: animated)
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

    func pushFromRootBack(viewController: WalletViewController, animated: Bool = true) {
        guard controller.viewControllers.count > 1 else {
            push(viewController: viewController, animated: animated)
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

    func popBack(nextViewController: (WalletViewController) -> Void) {
        controller.popViewController(animated: true)

        guard let next = controller.viewControllers.last as? WalletViewController else {
            return
        }
        
        return nextViewController(next)
    }

    var presentingController: WalletNavigationController?

    func present(viewController: WalletViewController, animate: Bool) {
        let childNavigationController = UINavigationController(rootViewController: viewController)
        presentingController = WalletNavigationController(navigationController: childNavigationController)
        presentingController!.controller.hero.isEnabled = true
        if animate {
            presentingController!.controller.hero.modalAnimationType = .selectBy(
                presenting: .slide(direction: .left),
                dismissing: .slide(direction: .right)
            )
        } else {
            presentingController!.controller.hero.modalAnimationType = .none
        }

        controller.present(presentingController!.controller, animated: true, completion: nil)

        hideBackButton(for: viewController)
    }

    func dismissPresentedViewController() {
        self.presentingController?.controller.hero.dismissViewController(completion: {
            self.presentingController = nil
        })
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
