//
//  WalletViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

typealias WalletViewControllerAlias = UIViewController & WalletViewController

protocol WalletViewController: AnyObject where Self: UIViewController {
    
    var migratingNavigationController: MigratingWalletNavigationController? { get }

    var migratingTabBarController: MigratingWalletTabBarController? { get }
}

extension WalletViewController {

    weak var migratingNavigationController: MigratingWalletNavigationController? {
        return navigationController as? MigratingWalletNavigationController
    }

    weak var migratingTabBarController: MigratingWalletTabBarController? {
        return tabBarController as? MigratingWalletTabBarController
    }
}
