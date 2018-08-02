//
//  WalletNavigationController.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Custom NavigationController that provides general style and behaviour according to design
 */
class WalletNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
    }

    private func setupStyle() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        navigationItem.hidesBackButton = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)

        viewController.navigationItem.hidesBackButton = true

        guard viewControllers.count > 2 else {
            return
        }

        showBackButton()
    }

    func pushViewControllerFromRoot(_ viewController: UIViewController, animated: Bool) {
        self.popToRootViewController(animated: true)

        super.pushViewController(viewController, animated: false)
    }

    func showBackButton() {
        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: self,
            action: #selector(backBarButtonItemTap(_:))
        )
        backItem.tintColor = .white
        viewControllers.last?.navigationItem.leftBarButtonItem = backItem
    }

    func addExitButton(target: Any?, action: Selector) {
        let exitButton = UIBarButtonItem(title: "EXIT",
                                         style: .plain,
                                         target: target,
                                         action: action)

        exitButton.tintColor = .skyBlue
        viewControllers.last?.navigationItem.rightBarButtonItem = exitButton
    }

    @objc
    private func backBarButtonItemTap(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
}
