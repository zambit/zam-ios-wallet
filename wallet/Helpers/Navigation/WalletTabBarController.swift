//
//  WalletTabBarController.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift

class WalletTabBarController {

    private(set) var controller: ESTabBarController

    weak var home: WalletViewController?
    weak var transactions: UIViewController?
    weak var zam: UIViewController?
    weak var contacts: UIViewController?
    weak var more: UIViewController?

    init(home: WalletViewController,
               transactions: UIViewController,
               zam: UIViewController,
               contacts: UIViewController,
               more: UIViewController) {

        self.home = home
        self.transactions = transactions
        self.zam = zam
        self.contacts = contacts
        self.more = more

        let tabBarController = ESTabBarController()

        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .automatic
            tabBar.barTintColor = UIColor.backgroundLighter
        }

        home.tabBarItem = ESTabBarItem(WalletContentView(), title: "Home", image: #imageLiteral(resourceName: "briefcaseCopy"), selectedImage: #imageLiteral(resourceName: "briefcaseCopy"))
        transactions.tabBarItem = ESTabBarItem(WalletContentView(), title: "Transactions", image: #imageLiteral(resourceName: "transaction"))
        zam.tabBarItem = ESTabBarItem(LargeWalletContentView(), title: nil, image: #imageLiteral(resourceName: "logo"))
        contacts.tabBarItem = ESTabBarItem(WalletContentView(), title: "Contacts", image: #imageLiteral(resourceName: "users"))
        more.tabBarItem = ESTabBarItem(WalletContentView(), title: "More", image: #imageLiteral(resourceName: "more"))

        tabBarController.viewControllers = [home, transactions, zam, contacts, more]
        tabBarController.tabBar.barTintColor = UIColor.backgroundLighter
        tabBarController.tabBar.clipsToBounds = true

        let size = UIScreen.main.bounds.size
        let origin = CGPoint(x: 0, y: -1 * (size.height - tabBarController.tabBar.bounds.height))
        let rect = CGRect(origin: origin, size: size)
        tabBarController.tabBar.backgroundImage = UIImage.gradientImage(colors: [.backgroundDarker, .backgroundLighter], locations: nil, frame: rect)

        controller = tabBarController
    }
}

class LargeWalletContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconColor = .white
        highlightIconColor = .white
        highlightEnabled = false

        renderingMode = .alwaysOriginal
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class WalletContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.white.withAlphaComponent(0.5)
        highlightTextColor = .white
        iconColor = UIColor.white.withAlphaComponent(0.5)
        highlightIconColor = .white
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
