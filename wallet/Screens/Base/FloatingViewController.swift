//
//  DetailViewPresentationViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class FloatingViewController: FlowViewController, WalletNavigable {

    enum State {
        case closed
        case open

        var opposite: State {
            switch self {
            case .open:
                return .closed
            case .closed:
                return .open
            }
        }
    }

    @IBOutlet var floatingView: UIView?
    @IBOutlet var floatingViewBottomConstraint: NSLayoutConstraint?

    /**
     Detail view initial offset.
     */
    var floatingViewInitialOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        floatingViewInitialOffset = floatingViewBottomConstraint?.constant ?? 0
    }

    /**
     The current state of the animation. This variable is changed only when an animation completes.
     */
    var currentState: State = .closed {
        didSet {
            stateDidChange(currentState)
        }
    }

    /**
     Pan gesture recognizers that contols animation.
     */
    var floatingPanGestureRecognizer: InstantPanGestureRecognizer {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(floatingPanGestureEvent(recognizer:)))
        return recognizer
    }

    /**
     All of the currently running animators.
     */
    private var runningAnimators: [UIViewPropertyAnimator] = []

    /**
     The progress of each animator. This array is parallel to the `runningAnimators` array.
     */
    private var animationProgress: [CGFloat] = []

    /**
     */
    func set(state: State) {
        let animators = createTransitionAnimatorsIfNeeded(to: state, duration: 1)
        animateTransitionsIfNeeded(animators)
    }

    /**
     State changing event handler. Provide access for observing currentState property.
     */
    func stateDidChange(_ state: State) {
        // state did change
    }

    /**
     Creates the transition animators depending on input state and duration. Override to add animations.
     */
    func createTransitionAnimatorsIfNeeded(to state: State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.floatingViewBottomConstraint?.constant = 50

            case .closed:
                self.floatingViewBottomConstraint?.constant = self.floatingViewInitialOffset

            }
            self.view.layoutIfNeeded()
        })

        // the transition completion block
        transitionAnimator.addCompletion { position in

            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }

            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.floatingViewBottomConstraint?.constant = 50
            case .closed:
                self.floatingViewBottomConstraint?.constant = self.floatingViewInitialOffset
            }

            // remove all running animators
            self.runningAnimators.removeAll()
        }

        return [transitionAnimator]
    }

    /**
     Animate input animators, if the animation is not already running.
     */
    private func animateTransitionsIfNeeded(_ animators: [UIViewPropertyAnimator]) {

        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }

        animators.forEach {
            // start all animators
            $0.startAnimation()

            // keep track of all running animators
            runningAnimators.append($0)
        }
    }

    /**
     Pan gesture recognizer event handler that controls transition state.
     */
    @objc
    func floatingPanGestureEvent(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:

            // start the animations
            let animators = createTransitionAnimatorsIfNeeded(to: currentState.opposite, duration: 1)
            animateTransitionsIfNeeded(animators)

            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }

            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }

        case .changed:

            // variable setup
            let translation = recognizer.translation(in: floatingView)
            var fraction = -translation.y / floatingViewInitialOffset

            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if let animator = runningAnimators.first, animator.isReversed { fraction *= -1 }

            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }

        case .ended:

            // variable setup
            let yVelocity = recognizer.velocity(in: floatingView).y
            let shouldClose = yVelocity > 0

            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }

            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if let animator = runningAnimators.first, animator.isReversed && !shouldClose { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if let animator = runningAnimators.first, animator.isReversed && shouldClose { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if let animator = runningAnimators.first, animator.isReversed && shouldClose { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if let animator = runningAnimators.first, animator.isReversed && !shouldClose { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }

            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }

        default:
            ()
        }
    }
}
