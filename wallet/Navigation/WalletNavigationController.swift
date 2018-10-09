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

    var custom: BehaviorExtension<WalletNavigationController> {
        return BehaviorExtension<WalletNavigationController>(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.custom.setupStyle()
    }

    @objc
    fileprivate func backBarButtonItemAction(_ sender: Any) {
        custom.popViewController(animated: true)
    }
}

extension BehaviorExtension where Base: WalletNavigationController {

    enum WalletNavigationControllerAnimationDirection {
        case forward
        case back
    }

    func setupHorizontalStyle() {
        base.navigationBar.applyDefaultGradientHorizontally()
    }

    func setupStyle() {
        setDefaultNavigationAnimationType()

        base.navigationBar.setBackgroundImage(UIImage(), for: .default)
        base.navigationBar.shadowImage = UIImage()
        base.navigationBar.backgroundColor = .clear
        base.navigationBar.isTranslucent = true
        base.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        base.navigationItem.hidesBackButton = true
    }

    private func setDefaultNavigationAnimationType() {
        base.hero.isEnabled = true
        base.hero.navigationAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
    }

    func push(viewController: ScreenWalletNavigable, animated: Bool = true) {
        base.pushViewController(viewController, animated: animated)
        hideBackButton(for: viewController)
        
        if base.viewControllers.count > 1 {
            addBackButton(for: viewController)
        }
    }

    func pushAdvancedly(viewController: ScreenWalletNavigable) {
        base.hero.isEnabled = true
        base.hero.navigationAnimationType = .selectBy(presenting: .fade, dismissing: .fade)

        push(viewController: viewController)
    }

    func pushFromRoot(viewController: ScreenWalletNavigable, animated: Bool = true, direction: WalletNavigationControllerAnimationDirection) {
        guard base.viewControllers.count > 0 else {
            push(viewController: viewController, animated: animated)
            hideBackButton(for: viewController)

            (viewController as? WalletTabBarController)?.navigationController?.setNavigationBarHidden(true, animated: false)
            return
        }

        switch direction {
        case .forward:

            base.pushViewController(viewController, animated: animated)
            hideBackButton(for: viewController)

            let newHierarchy = [viewController]
            base.setViewControllers(newHierarchy, animated: false)
            
        case .back:

            guard let currentViewController = base.viewControllers.last else {
                return
            }

            let newHierarchy = [viewController, currentViewController]
            base.setViewControllers(newHierarchy, animated: false)
            base.popViewController(animated: animated)

            hideBackButton(for: viewController)
        }

        if let tabBarController = viewController as? WalletTabBarController {
            tabBarController.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            viewController.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    func popViewController(animated: Bool) {
        let pop: () -> Void = {
            self.base.popViewController(animated: animated)
        }

        if let last = base.viewControllers.last as? FlowViewController {
            last.dismissKeyboard(completion: pop)
        } else {
            pop()
        }
    }

    func popBack(animated: Bool = true, nextViewController: (ScreenWalletNavigable) -> Void) {
        base.popViewController(animated: animated)

        guard let next = base.viewControllers.last as? ScreenWalletNavigable else {
            return
        }

        return nextViewController(next)
    }

    func present(viewController: UIViewController, animate: Bool) {
        viewController.hero.isEnabled = true

        if animate {
            viewController.hero.modalAnimationType = .selectBy(
                presenting: .slide(direction: .left),
                dismissing: .slide(direction: .right)
            )
        } else {
            viewController.hero.modalAnimationType = .none
        }

        viewController.modalPresentationStyle = .overFullScreen

        base.present(viewController, animated: true, completion: nil)
    }

    func presentNavigable(viewController: ScreenWalletNavigable, animate: Bool) {
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

    func hideBackButton(for viewController: UIViewController) {
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
            action: #selector(base.backBarButtonItemAction(_:))
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
