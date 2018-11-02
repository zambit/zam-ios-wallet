//
//  MigratingWalletTabBarController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class WalletTabBarController: ESTabBarController, WalletNavigable {

    override func viewDidLoad() {
        super.viewDidLoad()

        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: WalletTabBarController {

    func setupStyle() {
        if let tabBar = base.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .automatic
            tabBar.barTintColor = UIColor.backgroundLighter
        }

        base.tabBar.clipsToBounds = true

        let size = UIScreen.main.bounds.size
        let origin = CGPoint(x: 0, y: -1 * (size.height - base.tabBar.bounds.height))
        let rect = CGRect(origin: origin, size: size)
        base.tabBar.backgroundImage = UIImage.gradientImage(colors: [.backgroundDarker, .backgroundLighter], locations: nil, frame: rect)
    }

    /**
     Add given viewControllers to tabBar generating own navigationController hierarchy for each item.
     */
    func add(viewController: ScreenWalletNavigable? = nil, with item: WalletTabBarItemData) {
        guard let vc = viewController else {
            add(item: item)
            return
        }

        let rootItemController = WalletNavigationController(rootViewController: vc)
        rootItemController.tabBarItem = ESTabBarItem(item.type.view, title: item.title, image: item.image)

        let viewControllers = (base.viewControllers ?? []) + [rootItemController]
        base.viewControllers = viewControllers
    }

    /**
     Add given viewControllers to tabBar generating own navigationController hierarchy for each item.
     */
    func add(item: WalletTabBarItemData) {
        let viewController = EmptyViewController()
        viewController.tabBarItem = ESTabBarItem(item.type.view, title: item.title, image: item.image)
        viewController.tabBarItem.isEnabled = false

        let viewControllers = (base.viewControllers ?? []) + [viewController]
        base.viewControllers = viewControllers
    }

    /**
     `NavigationControllers` that provides own navigation hierachy for each tabBar item.

     `RootViewController` of each given `NavigationController` is `WalletViewController` that was provided in `add(viewController:with:)` method.
     */
    var rootViewControllers: [WalletNavigationController]? {
        get {
            return base.viewControllers?.compactMap {
                return $0 as? WalletNavigationController
            }
        }

        set {
            base.viewControllers = newValue
        }
    }
}
