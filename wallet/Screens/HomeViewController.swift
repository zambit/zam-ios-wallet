//
//  HomeViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol WalletsContainerEmbededViewController: class {

    var scrollView: UIScrollView? { get }
}

class HomeViewController: DetailOffsetPresentationViewController {

    var embededViewController: WalletsContainerEmbededViewController? {
        didSet {
            guard let embeded = embededViewController as? UIViewController else {
                return
            }

            walletsContainerView?.set(viewController: embeded, owner: self)
        }
    }

    // MARK: - Outlets

    @IBOutlet var detailGestureView: UIView?
    @IBOutlet var detailTopGestureView: UIView?

    @IBOutlet var detailTitleLabel: UILabel?

    @IBOutlet var walletsContainerView: ContainerView?

    @IBOutlet var sumTitleLabel: UILabel?
    @IBOutlet var sumTitleLeftConstraint: NSLayoutConstraint?

    @IBOutlet var sumLabel: UILabel?
    @IBOutlet var sumLeftConstraint: NSLayoutConstraint?
    @IBOutlet var sumTopConstraint: NSLayoutConstraint?

    @IBOutlet var sumBtcLabel: UILabel?
    @IBOutlet var sumBtcLeftConstraint: NSLayoutConstraint?

    @IBOutlet var cardView: CreditCardViewComponent?
    @IBOutlet var cardOffsetConstraint: NSLayoutConstraint?

    // MARK: - Sizing constraints

    @IBOutlet var detailViewHeight: NSLayoutConstraint?

    private var cardViewOffset: CGFloat = 0

    // MARK: - View Controller Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let detailTopView = detailTopGestureView {
            let point = CGPoint(x: detailTopView.bounds.width / 2.0, y: detailTopView.bounds.height / 4.0)
            drawIndicator(in: detailTopView, center: point)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupDefaultStyle()

        tabBarController?.navigationController?.isNavigationBarHidden = true

        switch UIDevice.current.screenType {
        case .extraSmall:
            detailViewHeight?.constant = 450.0
        case .small:
            detailViewHeight?.constant = 505.0
        case .medium:
            detailViewHeight?.constant = 600.0
        case .extra:
            detailViewHeight?.constant = 641.0
        case .plus:
            detailViewHeight?.constant = 670.0
        case .unknown:
            fatalError()
        }

        cardViewOffset = cardOffsetConstraint?.constant ?? 0

        detailGestureView?.addGestureRecognizer(panRecognizer)
        detailTopGestureView?.addGestureRecognizer(panRecognizer)

        walletsContainerView?.isUserInteractionEnabled = false

        if let embeded = embededViewController as? UIViewController {
            walletsContainerView?.set(viewController: embeded, owner: self)
        }
    }

    private func setupStyle() {
        detailView?.backgroundColor = .white
        detailGestureView?.backgroundColor = .clear

        detailView?.layer.cornerRadius = 16.0
        detailGestureView?.layer.cornerRadius = 16.0

        detailTitleLabel?.textColor = .darkIndigo
        detailTitleLabel?.text = "My accounts"

        sumTitleLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        sumTitleLabel?.textColor = .skyBlue
        sumTitleLabel?.text = "Total balance"

        sumBtcLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        sumBtcLabel?.textColor = .skyBlue
        sumBtcLabel?.text = "28.3467 BTC"

        var sumSymbolFont: UIFont = UIFont()
        var sumMainFont: UIFont = UIFont()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            sumSymbolFont = UIFont.walletFont(ofSize: 28.0, weight: .medium)
            sumMainFont = UIFont.walletFont(ofSize: 28.0, weight: .regular)
        case .medium, .extra, .plus:
            sumSymbolFont = UIFont.walletFont(ofSize: 36.0, weight: .medium)
            sumMainFont = UIFont.walletFont(ofSize: 36.0, weight: .regular)
        case .unknown:
            fatalError()
        }

        let attributedString = NSMutableAttributedString(string: "$ 212,456.00", attributes: [
            .font: sumSymbolFont,
            .foregroundColor: UIColor.white,
            .kern: -1.5
            ])

        attributedString.addAttributes([
            .font: sumMainFont,
            .foregroundColor: UIColor.skyBlue
            ], range: NSRange(location: 0, length: 1))

        attributedString.addAttributes([
            .font: UIFont.walletFont(ofSize: 18.0, weight: .regular),
            .foregroundColor: UIColor.skyBlue
            ], range: NSRange(location: 10, length: 2))

        sumLabel?.attributedText = attributedString

        detailTopGestureView?.applyGradient(colors: [.white, UIColor.white.withAlphaComponent(0.7), UIColor.white.withAlphaComponent(0.0)], locations: [0.0, 0.75, 1.0])

        embededViewController?.scrollView?.contentInset = UIEdgeInsetsMake(64, 0, 64, 0)
    }

    // MARK: - Animation

    override func stateDidChange(_ state: DetailOffsetPresentationViewController.State) {
        super.stateDidChange(state)

        switch state {
        case .open:
            walletsContainerView?.isUserInteractionEnabled = true
        case .closed:
            walletsContainerView?.isUserInteractionEnabled = false
        }
    }

    override func createTransitionAnimatorsIfNeeded(to state: DetailOffsetPresentationViewController.State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        guard let transitionAnimator = super.createTransitionAnimatorsIfNeeded(to: state, duration: duration).first else {
            fatalError()
        }

        // evaluate some values before setting animation

        var embededScrollViewOffset: CGPoint = .zero

        if let embededScrollViewInsets = embededViewController?.scrollView?.contentInset {
            embededScrollViewOffset = CGPoint(x: 0, y: -embededScrollViewInsets.top)
        }

        let sumLabelWidth: CGFloat = sumLabel?.bounds.width ?? 0

        // an animator for the transition
        transitionAnimator.addAnimations {
            switch state {
            case .open:

                self.detailView?.layer.cornerRadius = 0
                self.detailGestureView?.layer.cornerRadius = 0

                self.sumLabel?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.sumLeftConstraint?.constant = self.view.bounds.width / 2.0 - sumLabelWidth / 2.0
                self.sumTopConstraint?.constant = 0.0

                self.sumBtcLeftConstraint?.constant = -100

                self.sumTitleLabel?.alpha = 0.0
                self.sumTitleLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7

            case .closed:

                self.detailView?.layer.cornerRadius = 16.0
                self.detailGestureView?.layer.cornerRadius = 16.0

                self.sumLabel?.transform = .identity
                self.sumLeftConstraint?.constant = 16.0
                self.sumTopConstraint?.constant = 55.0

                self.sumBtcLeftConstraint?.constant = 16.0

                self.sumTitleLabel?.alpha = 1.0
                self.sumTitleLeftConstraint?.constant = 16.0

                self.embededViewController?.scrollView?.setContentOffset(embededScrollViewOffset, animated: false)
            }
            self.view.layoutIfNeeded()
        }

        // an animator for the title that is transitioning into view
        let cardAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.cardOffsetConstraint?.constant = -60
            case .closed:
                self.cardOffsetConstraint?.constant = self.cardViewOffset
            }

            self.view.layoutIfNeeded()
        })

        return [transitionAnimator, cardAnimator]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TransitionToEmbededViewController"),
            let embeded = segue.destination as? WalletsContainerEmbededViewController {

            self.embededViewController = embeded

            print("prepareForSegue")
        }
    }
}
