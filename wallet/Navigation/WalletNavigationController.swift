//
//  MigratingWalletNavigationController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 04/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Hero

/**
 Custom navigation controller, that have implemented custom extension behavior.
 */
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

/**
 Extension determining custom behavior of `WalletNavigationController`
 */
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

    /**
     Push given view controller to navigation hierarchy.

     - parameter viewController: View controller for pushing.
     - parameter animated: Animation flag.
     */
    func push(viewController: ScreenWalletNavigable, animated: Bool = true) {
        base.pushViewController(viewController, animated: animated)
        removeBackButton(in: viewController)
        
        if base.viewControllers.count > 1 {
            addBackButton(in: viewController)
        }
    }

    /**
     Push given view controller to navigation hierarchy with non-default fade animation.

     - parameter viewController: View controller for pushing.
     */
    func pushAdvancedly(viewController: ScreenWalletNavigable) {
        base.hero.isEnabled = true
        base.hero.navigationAnimationType = .selectBy(presenting: .fade, dismissing: .fade)

        push(viewController: viewController)
    }

    /**
     Push given view controller to navigation hierarchy clearing current navigation stack.

     - parameter viewController: View controller for pushing.
     - parameter animated: Animation flag.
     - parameter direction: Direction of animation (imitate moving forward/back)
     */
    func pushFromRoot(viewController: ScreenWalletNavigable, animated: Bool = true, direction: WalletNavigationControllerAnimationDirection) {

        guard base.viewControllers.count > 0 else {
            push(viewController: viewController, animated: animated)
            removeBackButton(in: viewController)

            (viewController as? WalletTabBarController)?.navigationController?.setNavigationBarHidden(true, animated: false)
            return
        }

        switch direction {
        case .forward:

            base.pushViewController(viewController, animated: animated)
            removeBackButton(in: viewController)

            let newHierarchy = [viewController]
            base.setViewControllers(newHierarchy, animated: false)
            
        case .back:

            guard let currentViewController = base.viewControllers.last else {
                return
            }

            let newHierarchy = [viewController, currentViewController]
            base.setViewControllers(newHierarchy, animated: false)
            base.popViewController(animated: animated)

            removeBackButton(in: viewController)
        }

        if let tabBarController = viewController as? WalletTabBarController {
            tabBarController.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            viewController.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    /**
     Pop last view controller from navigation stack.

     - parameter animated: Animation flag.
     */
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

    /**
     Pop last view controller from navigation stack, returning new last view controller.

     - parameter animated: Animation flag.
     - parameter nextViewController: New last view controller in navigation hierachy.
     */
    func popBack(animated: Bool = true, nextViewController: (ScreenWalletNavigable) -> Void) {
        base.popViewController(animated: animated)

        guard let next = base.viewControllers.last as? ScreenWalletNavigable else {
            return
        }

        return nextViewController(next)
    }

    /**
     Present given view controller outside current navigation hierachy with navigation animation.

     - parameter viewController: View controller for presenting.
     - parameter animated: Animation flag.
     */
    func present(viewController: UIViewController, animated: Bool) {
        viewController.hero.isEnabled = true

        if animated {
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

    /**
     Present new navigation hierachy, with given view controller as root, outside current navigation hierachy.

     - parameter viewController: Root view controller for new navigation hierarchy.
     - parameter animated: Animation flag.
     */
    func presentNavigable(viewController: ScreenWalletNavigable, animated: Bool) {
        let childNavigationController = WalletNavigationController(rootViewController: viewController)
        childNavigationController.hero.isEnabled = true

        if animated {
            childNavigationController.hero.modalAnimationType = .selectBy(
                presenting: .slide(direction: .left),
                dismissing: .slide(direction: .right)
            )
        } else {
            childNavigationController.hero.modalAnimationType = .none
        }

        childNavigationController.modalPresentationStyle = .overFullScreen
        base.present(childNavigationController, animated: true, completion: nil)

        removeBackButton(in: viewController)
    }

    /**
     Present new navigation hierachy, with given view controller as root, outside current navigation hierachy.

     - parameter viewController: Root view controller for new navigation hierarchy.
     - parameter animated: Animation flag.
     */
    func dismissPresentedViewController() {
        base.presentedViewController?.hero.dismissViewController()
    }

    /**
     Remove back button in given view controller.

     - parameter viewController: View controller for removing back button.
     */
    func removeBackButton(in viewController: UIViewController) {
        viewController.navigationItem.hidesBackButton = true

        viewController.navigationItem.leftBarButtonItem = nil
    }

    /**
     Add custom style back button to given view controller with given action.

     - parameter viewController: View controller for removing back button.
     - parameter target: Object holding action selector.
     - parameter action: Action selector for button.
     */
    func addBackButton(in viewController: ScreenWalletNavigable, target: Any?, action: Selector) {
        removeBackButton(in: viewController)

        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: target,
            action: action
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    /**
     Add custom style back button to given view controller with default back action.

     - parameter viewController: View controller for removing back button.
     */
    func addBackButton(in viewController: ScreenWalletNavigable) {
        removeBackButton(in: viewController)

        let backItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "icArrowLeft"),
            style: .plain,
            target: base,
            action: #selector(base.backBarButtonItemAction(_:))
        )
        backItem.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = backItem
    }

    /**
     Add custom style right bar button with given parameters.

     - parameter viewController: View controller for removing back button.
     - parameter title: Button title.
     - parameter target: Object holding action selector.
     - parameter action: Action selector for button.
     */
    func addRightDetailButton(in viewController: ScreenWalletNavigable, title: String, target: Any?, action: Selector) {
        let exitButton = UIBarButtonItem(title: title,
                                         style: .plain,
                                         target: target,
                                         action: action)

        exitButton.tintColor = .skyBlue
        viewController.navigationItem.rightBarButtonItem = exitButton
    }
}
