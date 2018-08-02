//
//  NavigationAnimator.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

enum NavigationCustomOperation {

    case show
    case hide
    case idle

    init(operation: UINavigationControllerOperation) {
        switch operation {
        case .pop:
            self = .hide
        case .push:
            self = .show
        case .none:
            self = .idle
        }
    }
}

class NavigationCustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: NavigationCustomOperation = .idle
    var duration = 0.6

    let damping: CGFloat = 0.9
    let initialSpringVelocity: CGFloat = 0.1

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard operation != .idle else {
            transitionContext.completeTransition(true)
            return
        }

        let containerView = transitionContext.containerView
        containerView.applyDefaultGradient()

        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!

        let moveRight = (operation != .show)

        let distance = containerView.bounds.width
        let relativeDistance = moveRight ? distance : -distance

        let travelPoint = CGPoint(x: relativeDistance, y: 0)

        containerView.addSubview(toViewController.view)

        toViewController.view.frame.origin = travelPoint.inverted

        if (operation == .hide) {
            // hack
            for subview in toViewController.view.subviews {
                subview.clipsToBounds = false
            }
        }

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: {
            fromViewController.view.frame.origin = travelPoint
            toViewController.view.frame.origin = CGPoint.zero
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
