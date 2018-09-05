//
//  MigratingWalletNavigationController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 04/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Hero

class WalletNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.custom.setupStyle()
    }
}

extension BehaviorExtension where Base: WalletNavigationController {

    enum WalletNavigationControllerAnimationDirection {
        case forward
        case back
    }

    func setupStyle() {
        base.hero.isEnabled = true
        base.hero.navigationAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))

        base.navigationBar.setBackgroundImage(UIImage(), for: .default)
        base.navigationBar.shadowImage = UIImage()
        base.navigationBar.backgroundColor = .clear
        base.navigationBar.isTranslucent = true
        base.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        base.navigationItem.hidesBackButton = true
    }

    func push(viewController: ScreenWalletNavigable, animated: Bool = true) {
        base.pushViewController(viewController, animated: animated)
        hideBackButton(for: viewController)
        
        if base.viewControllers.count > 1 {
            addBackButton(for: viewController)
        }
    }

    func pushFromRoot(viewController: ScreenWalletNavigable, animated: Bool = true, direction: WalletNavigationControllerAnimationDirection) {
        guard base.viewControllers.count > 1 else {
            push(viewController: viewController, animated: animated)
            hideBackButton(for: viewController)

            (viewController as? WalletTabBarController)?.navigationController?.setNavigationBarHidden(true, animated: false)

            return
        }

        switch direction {
        case .forward:

            base.pushViewController(viewController, animated: animated)
            hideBackButton(for: viewController)

            guard let root = base.viewControllers.first else {
                return
            }

            let newHierarchy = [root, viewController]
            base.setViewControllers(newHierarchy, animated: false)
            
        case .back:

            guard
                let currentViewController = base.viewControllers.last,
                let root = base.viewControllers.first else {
                    return
            }

            let newHierarchy = [root, viewController, currentViewController]
            base.setViewControllers(newHierarchy, animated: false)
            base.popViewController(animated: animated)

            hideBackButton(for: viewController)
        }

        (viewController as? WalletTabBarController)?.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func popBack(animated: Bool = true, nextViewController: (WalletNavigable) -> Void) {
        base.popViewController(animated: animated)

        guard let next = base.viewControllers.last as? WalletNavigable else {
            return
        }

        return nextViewController(next)
    }

    func present(viewController: ScreenWalletNavigable, animate: Bool) {
        let childNavigationController = WalletNavigationController(rootViewController: viewController)
        childNavigationController.hero.isEnabled = true

        if animate {
            childNavigationController.hero.modalAnimationType = .selectBy(
                presenting: .slide(direction: .left),
                dismissing: .slide(direction: .right)
            )
        } else {
            childNavigationController.hero.modalAnimationType = .none
        }

        childNavigationController.modalPresentationStyle = .overFullScreen

        base.present(childNavigationController, animated: true, completion: nil)

        hideBackButton(for: viewController)
    }

    func dismissPresentedViewController() {
        base.presentedViewController?.hero.dismissViewController()
    }

    func hideBackButton(for viewController: ScreenWalletNavigable) {
        viewController.navigationItem.hidesBackButton = true

        viewController.navigationItem.leftBarButtonItem = nil
    }

    func addBackButton(for viewController: ScreenWalletNavigable, target: Any?, action: Selector) {
        hideBackButton(for: viewController)

        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: target,
            action: action
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    func addBackButton(for viewController: ScreenWalletNavigable) {
        hideBackButton(for: viewController)

        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: base,
            action: #selector(base.popViewController(animated:))
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    func addRightBarItemButton(for viewController: ScreenWalletNavigable, title: String, target: Any?, action: Selector) {
        let exitButton = UIBarButtonItem(title: title,
                                         style: .plain,
                                         target: target,
                                         action: action)

        exitButton.tintColor = .skyBlue
        viewController.navigationItem.rightBarButtonItem = exitButton
    }

}
