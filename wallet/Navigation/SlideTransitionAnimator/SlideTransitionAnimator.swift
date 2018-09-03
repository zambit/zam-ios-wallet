//
//  SlideTransitionAnimator.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: TransitionOperation = .idle
    var duration = 0.6

    let damping: CGFloat = 0.9
    let initialSpringVelocity: CGFloat = 0.1

    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        switch operation {
        case .present, .dismiss:
            animateSlidingTransitionViewController(using: transitionContext, operation: operation)
        case .push, .pop:
            animateSlidingTransitionInsideNavigationController(using: transitionContext, operation: operation)
        case .idle:
            transitionContext.completeTransition(true)
        }

    }

    private func animateSlidingTransitionViewController(using transitionContext: UIViewControllerContextTransitioning, operation: TransitionOperation) {

        guard operation == .present || operation == .dismiss else {
            transitionContext.completeTransition(true)
            return
        }

        let isPresenting: Bool = (operation == .present) ? true : false

        let containerView = transitionContext.containerView
            containerView.applyDefaultGradient()

        var toViewController = transitionContext.viewController(forKey: .to)!

        if !isPresenting {
            if let toNav = toViewController as? UINavigationController {

                guard let last = toNav.viewControllers.last else {
                    transitionContext.completeTransition(true)
                    return
                }

                toViewController = last
            }
        }

        let toView = toViewController.view!
        let targetView = isPresenting ? toView : transitionContext.view(forKey: .from)!

        let moveRight = (operation != .present)

        let distance = containerView.bounds.width
        let relativeDistance = moveRight ? distance : -distance

        let travelPoint = CGPoint(x: relativeDistance, y: 0)

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: targetView)

        if isPresenting {
            targetView.frame.origin = travelPoint.inverted
        }

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: {
            targetView.frame.origin = isPresenting ? CGPoint.zero : travelPoint
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })

//        let initialFrame = isPresenting ? originFrame : targetView.frame
//        let finalFrame = isPresenting ? targetView.frame : originFrame
//
//        let xScaleFactor = isPresenting ?
//            initialFrame.width / finalFrame.width :
//            finalFrame.width / initialFrame.width
//
//        let yScaleFactor = isPresenting ?
//            initialFrame.height / finalFrame.height :
//            finalFrame.height / initialFrame.height
//
//        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
//
//        if isPresenting {
//            targetView.transform = scaleTransform
//            targetView.center = CGPoint(
//                x: initialFrame.midX,
//                y: initialFrame.midY)
//            targetView.clipsToBounds = true
//        }
//
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: targetView)
//
//        UIView.animate(withDuration: duration, delay:0.0,
//                       usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
//                       animations: {
//                        targetView.transform = isPresenting ? .identity : scaleTransform
//                        targetView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//        }, completion: { _ in
////            if !self.isPresenting {
////                self.dismissCompletion?()
////            }
//            transitionContext.completeTransition(true)
//        })
    }

    private func animateSlidingTransitionInsideNavigationController(using transitionContext: UIViewControllerContextTransitioning, operation: TransitionOperation) {

        guard operation == .push || operation == .pop else {
            return
        }

        let containerView = transitionContext.containerView
            containerView.applyDefaultGradient()

        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!

        let moveRight = (operation != .push)

        let distance = containerView.bounds.width
        let relativeDistance = moveRight ? distance : -distance

        let travelPoint = CGPoint(x: relativeDistance, y: 0)

        containerView.addSubview(toViewController.view)

        toViewController.view.frame.origin = travelPoint.inverted

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseInOut, animations: {
            fromViewController.view.frame.origin = travelPoint
            toViewController.view.frame.origin = CGPoint.zero
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
