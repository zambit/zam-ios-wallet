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
        if let animator = animator as? NavigationCustomAnimator {
            animator.operation = NavigationCustomOperation(operation: operation)
            return animator
        }

        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animator = animator as? NavigationCustomAnimator {
            animator.operation = .hide
            return animator
        }

        return nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animator = animator as? NavigationCustomAnimator {
            animator.operation = .show
            return animator
        }

        return nil
    }
}
