//
//  WalletNavigationController.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

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

        navigationItem.hidesBackButton = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)

        guard viewControllers.count > 1 else {
            return
        }

        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: self,
            action: #selector(backBarButtonItemTap(_:))
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    @objc
    private func backBarButtonItemTap(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
}
