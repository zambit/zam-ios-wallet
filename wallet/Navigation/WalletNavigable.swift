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
    
    var walletNavigationController: WalletNavigationController? { get }

    var walletTabBarController: WalletTabBarController? { get }
}

extension WalletNavigable {

    weak var walletNavigationController: WalletNavigationController? {
        return navigationController as? WalletNavigationController
    }

    weak var walletTabBarController: WalletTabBarController? {
        return tabBarController as? WalletTabBarController
    }
}
