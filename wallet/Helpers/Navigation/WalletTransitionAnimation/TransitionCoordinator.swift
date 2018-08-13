//
//  TransitionCoordinator.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    private let animator: UIViewControllerAnimatedTransitioning

    init(animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let animator = animator as? NavigationCustomAnimator else {
            return nil
        }

        animator.operation = NavigationCustomOperation(operation: operation)
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator as? NavigationCustomAnimator else {
            return nil
        }

        animator.operation = .hide
        return animator
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator as? NavigationCustomAnimator else {
            return nil
        }

        animator.operation = .show
        return animator
    }
}
