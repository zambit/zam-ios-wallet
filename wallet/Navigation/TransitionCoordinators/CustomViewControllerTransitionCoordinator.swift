//
//  ViewControllerTransitionCoordinator.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CustomViewControllerTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {

    private let animator: UIViewControllerAnimatedTransitioning

    init(animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator as? SlideTransitionAnimator else {
            return nil
        }

        animator.operation = .dismiss
        return animator
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator as? SlideTransitionAnimator else {
            return nil
        }

        animator.operation = .present
        return animator
    }
}
