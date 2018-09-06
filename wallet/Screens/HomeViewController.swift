//
//  HomeViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: DetailOffsetPresentationViewController, WalletsViewControllerDelegate, ContactsHorizontalComponentDelegate {

    var contactsManager: UserContactsManager?
    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    var embededViewController: WalletsViewController? {
        didSet {
            guard let embeded = embededViewController else {
                return
            }

            walletsContainerView?.set(viewController: embeded, owner: self)
        }
    }

    // MARK: - Outlets

    @IBOutlet var contactsComponent: ContactsHorizontalComponent?

    @IBOutlet var detailViewHeight: NSLayoutConstraint?

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

    private var cardViewOffset: CGFloat = 0
    private var sumLeftLabelOffset: CGFloat = 0
    private var sumLeftTargetLabelOffset: CGFloat = 0

    // MARK: - Data

    private var totalBalance: BalanceData?

    // MARK: - View Controller Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isContactsLoading {
            contactsComponent?.contactsCollectionView?.beginLoading()
        } else {
            contactsComponent?.contactsCollectionView?.endLoading()
        }
    }

    private var isContactsLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupDefaultStyle()

        hideKeyboardOnTap()

        isContactsLoading = true

        contactsManager?.fetchContacts {
            [weak self]
            contacts in

            self?.isContactsLoading = false

            if !contacts.isEmpty {
                self?.contactsComponent?.delegate = self
                self?.contactsComponent?.contactsCollectionView?.endLoading()
                self?.contactsComponent?.prepare(contacts: contacts)
                self?.detailViewOffset = 350

            } else {

                self?.contactsComponent?.contactsCollectionView?.endLoading()
                self?.detailViewOffset = 200

                if self?.currentState == .closed {
                    self?.animate(to: .closed)
                }
            }
        }

        switch UIDevice.current.screenType {
        case .small, .extraSmall:
            detailViewHeight?.constant = 515.0
        case .medium:
            detailViewHeight?.constant = 600.0
        case .extra:
            detailViewHeight?.constant = 691.0
        case .plus:
            detailViewHeight?.constant = 675.0
        case .unknown:
            fatalError()
        }

        cardViewOffset = cardOffsetConstraint?.constant ?? 0
        sumLeftLabelOffset = sumLeftConstraint?.constant ?? 0

        detailGestureView?.addGestureRecognizer(panRecognizer)
        detailTopGestureView?.addGestureRecognizer(panRecognizer)

        walletsContainerView?.isUserInteractionEnabled = true

        if let embeded = embededViewController {
            walletsContainerView?.set(viewController: embeded, owner: self)
            embeded.delegate = self
        }

        view.clipsToBounds = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let detailTopView = detailTopGestureView {
            let point = CGPoint(x: detailTopView.bounds.width / 2.0, y: detailTopView.bounds.height / 4.0)
            drawIndicator(in: detailTopView, center: point)
        }
    }

    private func setupStyle() {
        detailView?.layer.cornerRadius = 16.0
        detailView?.clipsToBounds = true

        detailView?.backgroundColor = .white
        detailGestureView?.backgroundColor = .clear

        detailTitleLabel?.textColor = .darkIndigo
        detailTitleLabel?.text = "My accounts"

        sumTitleLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        sumTitleLabel?.textColor = .skyBlue
        sumTitleLabel?.text = "Total balance"

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

        let attributedString = NSMutableAttributedString(string: "$ 0.00", attributes: [
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
            ], range: NSRange(location: 4, length: 2))

        sumLabel?.attributedText = attributedString

        sumBtcLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        sumBtcLabel?.textColor = .skyBlue
        sumBtcLabel?.text = "0.0 BTC"

        detailTopGestureView?.applyGradient(colors: [.white, UIColor.white.withAlphaComponent(0.7), UIColor.white.withAlphaComponent(0.0)], locations: [0.0, 0.75, 1.0])

        embededViewController?.collectionView?.contentInset = UIEdgeInsetsMake(64, 0, 64, 0)
    }

    private func loadData() {
        guard let token = userManager?.getToken() else {
            return
        }

        dataWillLoading()

        userAPI?.getUserInfo(token: token, coin: nil).done {
            [weak self]
            info in

            guard let totalBalance = info.balances.first else {
                return
            }

            self?.totalBalance = totalBalance

            performWithDelay {
                self?.dataWasLoaded()
            }
        }.catch {
            [weak self]
            error in
            self?.dataWasntLoaded()
        }
    }

    private func dataWillLoading() {
        sumLabel?.endLoading()
        sumLabel?.beginLoading()
    }

    private func dataWasntLoaded() {
        sumLabel?.endLoading()
    }

    private func dataWasLoaded() {
        sumLabel?.endLoading()

        guard
            let totalBalance = totalBalance,
            let separator = NumberFormatter.walletAmount.decimalSeparator!.first else {
            return
        }

        let usdBalance = totalBalance.description(currency: .usd)
        let parts = usdBalance.split(separator: separator)
        guard parts.count == 2 else { return }

        let primary = String(parts[0])
        let fraction = String(parts[1])

        let primaryRange = 2..<primary.count+1
        let fractionRange = (primary.count + 1)..<(primary.count + 1 + fraction.count)
        setupTotalBalanceLabel(text: usdBalance, primaryStyleRange: primaryRange, fractionStyleRange: fractionRange)

        sumBtcLabel?.text = "\(totalBalance.formatted(currency: .original)) \(totalBalance.coin.short.uppercased())"
    }

    private func setupTotalBalanceLabel(text: String, primaryStyleRange: CountableRange<Int>, fractionStyleRange: CountableRange<Int>) {

        var sumSymbolFont: UIFont = UIFont()
        var sumMainFont: UIFont = UIFont()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            sumSymbolFont = UIFont.walletFont(ofSize: 28.0, weight: .regular)
            sumMainFont = UIFont.walletFont(ofSize: 28.0, weight: .medium)
        case .medium, .extra, .plus:
            sumSymbolFont = UIFont.walletFont(ofSize: 36.0, weight: .regular)
            sumMainFont = UIFont.walletFont(ofSize: 36.0, weight: .medium)
        case .unknown:
            fatalError()
        }

        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: sumSymbolFont,
            .foregroundColor: UIColor.skyBlue
            ])

        attributedString.addAttributes([
            .font: sumMainFont,
            .foregroundColor: UIColor.white,
            .kern: -1.5
            ], range: NSRange(location: primaryStyleRange.lowerBound, length: primaryStyleRange.count))

        attributedString.addAttributes([
            .font: UIFont.walletFont(ofSize: 18.0, weight: .regular),
            .foregroundColor: UIColor.skyBlue
            ], range: NSRange(location: fractionStyleRange.lowerBound, length: fractionStyleRange.count))

        sumLabel?.attributedText = attributedString
        sumLabel?.attributedText = attributedString
    }

    // MARK: - WalletsViewControllerDelegate

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController) {
        loadData()
    }

    // MARK: - ContactsHorizontalComponentDelegate

    func contactsHorizontalComponent(_ contactsHorizontalComponent: ContactsHorizontalComponent, itemWasTapped contactData: ContactData) {
        embededViewController?.onSendWithContact(contactData)
    }

    // MARK: - Animation

    override func stateDidChange(_ state: DetailOffsetPresentationViewController.State) {
        super.stateDidChange(state)

        // evaluate some values before setting animation

        let sumLabelWidth: CGFloat = sumLabel?.bounds.width ?? 0

        switch state {
        case .open:
            self.sumLabel?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.sumLeftConstraint?.constant = self.view.bounds.width / 2.0 - sumLabelWidth / 2.0
            self.sumTopConstraint?.constant = 0.0

            self.sumBtcLeftConstraint?.constant = -(self.sumLabel?.bounds.width ?? 200.0)

            self.sumTitleLabel?.alpha = 0.0
            self.sumTitleLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7

            self.contactsComponent?.changeLayouts()

            self.cardOffsetConstraint?.constant = -60

        case .closed:
            self.sumLabel?.transform = .identity
            self.sumLeftConstraint?.constant = 16.0
            self.sumTopConstraint?.constant = 55.0

            self.sumBtcLeftConstraint?.constant = 16.0

            self.sumTitleLabel?.alpha = 1.0
            self.sumTitleLeftConstraint?.constant = 16.0

            self.embededViewController?.scrollWalletsToTop()

            self.contactsComponent?.resetLayouts()

            self.cardOffsetConstraint?.constant = self.cardViewOffset
        }
    }

    override func createTransitionAnimatorsIfNeeded(to state: DetailOffsetPresentationViewController.State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        guard let transitionAnimator = super.createTransitionAnimatorsIfNeeded(to: state, duration: duration).first else {
            fatalError()
        }

        self.contactsComponent?.searchTextField?.resignFirstResponder()

        // evaluate some values before setting animation

        let sumLabelWidth: CGFloat = sumLabel?.bounds.width ?? 0

        // an animator for the transition
        transitionAnimator.addAnimations {
            switch state {
            case .open:
                self.sumLabel?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.sumLeftConstraint?.constant = self.view.bounds.width / 2.0 - sumLabelWidth / 2.0
                self.sumTopConstraint?.constant = 0.0

                self.sumBtcLeftConstraint?.constant = -(self.sumLabel?.bounds.width ?? 200.0)

                self.sumTitleLabel?.alpha = 0.0
                self.sumTitleLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7

                self.contactsComponent?.scrollContactsToHide()
                self.contactsComponent?.changeLayouts()

                self.cardOffsetConstraint?.constant = -60

            case .closed:
                self.sumLabel?.transform = .identity
                self.sumLeftConstraint?.constant = 16.0
                self.sumTopConstraint?.constant = 55.0

                self.sumBtcLeftConstraint?.constant = 16.0

                self.sumTitleLabel?.alpha = 1.0
                self.sumTitleLeftConstraint?.constant = 16.0

                self.embededViewController?.scrollWalletsToTop()

                self.contactsComponent?.scrollContactsBack()
                self.contactsComponent?.resetLayouts()

                self.cardOffsetConstraint?.constant = self.cardViewOffset
            }
            self.view.layoutIfNeeded()
        }

        return [transitionAnimator]
    }
}
