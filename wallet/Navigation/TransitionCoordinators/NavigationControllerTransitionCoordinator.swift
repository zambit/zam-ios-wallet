//
//  NavigationControllerTransitionCoordinator.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerTransitionCoordinator: NSObject, UINavigationControllerDelegate {

    private let animator: UIViewControllerAnimatedTransitioning

    init(animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let animator = animator as? SlideTransitionAnimator else {
            return nil
        }

        animator.operation = TransitionOperation(operation: operation)
        return animator
    }
}
