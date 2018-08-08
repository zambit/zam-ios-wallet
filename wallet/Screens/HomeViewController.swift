//
//  HomeViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: DetailOffsetPresentationViewController {

    // MARK: - Outlets

    @IBOutlet var detailGestureView: UIView?

    @IBOutlet var scrollView: UIScrollView?

    @IBOutlet var sumLabel: UILabel?
    @IBOutlet var leftConstraint: NSLayoutConstraint?
    @IBOutlet var topConstraint: NSLayoutConstraint?

    @IBOutlet var cardView: UIView?
    @IBOutlet var cardOffsetConstraint: NSLayoutConstraint?

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        detailGestureView?.addGestureRecognizer(panRecognizer)
    }

    // MARK: - Animation

    override func stateDidChange(_ state: DetailOffsetPresentationViewController.State) {
        super.stateDidChange(state)

        scrollView?.isUserInteractionEnabled = currentState == .open
    }


    override func createTransitionAnimatorsIfNeeded(to state: DetailOffsetPresentationViewController.State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        guard let transitionAnimator = super.createTransitionAnimatorsIfNeeded(to: state, duration: duration).first else {
            fatalError()
        }


        // an animator for the transition
        transitionAnimator.addAnimations {
            switch state {
            case .open:

                self.sumLabel?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.leftConstraint?.constant = 127.0
                self.topConstraint?.constant = 6.0

            case .closed:

                self.sumLabel?.transform = .identity
                self.leftConstraint?.constant = 16.0
                self.topConstraint?.constant = 55.0

            }
            self.view.layoutIfNeeded()
        }


        // an animator for the title that is transitioning into view
        let cardAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.cardOffsetConstraint?.constant = -60
            case .closed:
                self.cardOffsetConstraint?.constant = 144
            }

            self.view.layoutIfNeeded()
        })

        return [transitionAnimator, cardAnimator]
    }
}
