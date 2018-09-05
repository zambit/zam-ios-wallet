//
//  MigratingWalletTabBarController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MigratingWalletTabBarController: ESTabBarController, WalletViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        custom.setupStyle()
    }

}

extension BehaviorExtension where Base: MigratingWalletTabBarController {

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
    func add(viewController: WalletViewControllerAlias, with item: MigratingWalletTabBarItemData) {
        let rootItemController = MigratingWalletNavigationController(rootViewController: viewController)
        rootItemController.tabBarItem = ESTabBarItem(item.type.view, title: item.title, image: item.image)

        let viewControllers = (base.viewControllers ?? []) + [rootItemController]
        base.viewControllers = viewControllers
    }

    /**
     `NavigationControllers` that provides own navigation hierachy for each tabBar item.

     `RootViewController` of each given `NavigationController` is `WalletViewController` that was provided in `add(viewController:with:)` method.
     */
    var rootViewControllers: [MigratingWalletNavigationController]? {
        get {
            return base.viewControllers?.compactMap {
                return $0 as? MigratingWalletNavigationController
            }
        }

        set {
            base.viewControllers = newValue
        }
    }
}
