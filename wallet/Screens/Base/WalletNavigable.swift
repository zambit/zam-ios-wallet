//
//  WalletViewController.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

typealias ScreenWalletNavigable = UIViewController & WalletNavigable

protocol WalletNavigable where Self: UIViewController {
    
    var migratingNavigationController: WalletNavigationController? { get }

    var migratingTabBarController: WalletTabBarController? { get }
}

extension WalletNavigable {

    weak var migratingNavigationController: WalletNavigationController? {
        return navigationController as? WalletNavigationController
    }

    weak var migratingTabBarController: WalletTabBarController? {
        return tabBarController as? WalletTabBarController
    }
}
