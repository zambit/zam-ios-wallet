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
 Custom NavigationController that provides general style and behaviour according to design
 */
class WalletNavigationController {

    private(set) var controller: UINavigationController

    init(navigationController: UINavigationController, customTransitionCoordinator: TransitionCoordinator) {
        navigationController.delegate = customTransitionCoordinator
        navigationController.transitioningDelegate = customTransitionCoordinator

        self.navigationController = navigationController
        setupStyle(for: self.navigationController)
    }

    private func setupStyle(for navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        navigationController.navigationItem.hidesBackButton = true
    }

    func push(viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)

        addBackButton(for: viewController)
    }

    func pushFromRoot(viewController: UIViewController) {
        guard let currentViewController = navigationController.viewControllers.last,
            let root = navigationController.viewControllers.first else {
            return
        }
        let newHierarchy = [root, viewController, currentViewController]
        navigationController.setViewControllers(newHierarchy, animated: false)
        navigationController.popViewController(animated: true)

        viewController.navigationItem.leftBarButtonItem = nil
    }

    func addBackButton(for viewController: UIViewController) {
        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: self,
            action: #selector(backBarButtonItemTap(_:))
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    func addRightBarItemButton(for viewController: UIViewController, title: String, target: Any?, action: Selector) {
        let exitButton = UIBarButtonItem(title: title,
                                         style: .plain,
                                         target: target,
                                         action: action)

        exitButton.tintColor = .skyBlue
        viewController.navigationItem.rightBarButtonItem = exitButton
    }

    @objc
    private func backBarButtonItemTap(_ sender: UIBarButtonItem) {
        self.navigationController.popViewController(animated: true)
    }

}
