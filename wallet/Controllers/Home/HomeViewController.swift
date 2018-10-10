//
//  HomeViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

/**
 Protocol that provides interface to call some methods of home screen.
 */
protocol HomeController: class {

    func performSendFromWallet(index: Int, wallets: [WalletData], phone: String, recipient: FormattedContactData?)

    func performDepositFromWallet(index: Int, wallets: [WalletData], phone: String)

    func performWalletDetails(index: Int, wallets: [WalletData], phone: String)
}

class HomeViewController: FloatingViewController, WalletsViewControllerDelegate, ContactsHorizontalComponentDelegate, AdvancedTransitionDelegate, SendMoneyViewControllerDelegate, HomeController {

    var contactsManager: UserContactsManager?
    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    var onSendFromWallet: ((_ index: Int, _ wallets: [WalletData], _ recipient: FormattedContactData?, _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [WalletData], _ phone: String) -> Void)?
    var onWalletDetails: ((_ index: Int, _ wallets: [WalletData], _ phone: String) -> Void)?

    var walletsCollectionViewController: WalletsCollectionViewController? {
        didSet {
            guard let embeded = walletsCollectionViewController else {
                return
            }

            walletsContainerView?.set(viewController: embeded, owner: self)
            walletsCollectionViewController?.delegate = self
        }
    }

    lazy var viewsAnimationBlock: (State) -> Void = {
        [weak self]
        state in

        guard let strongSelf = self else {
            return
        }

        let sumLabelWidth: CGFloat = strongSelf.sumLabel?.bounds.width ?? 0

        switch state {
        case .open:
            strongSelf.sumLabel?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            strongSelf.sumLeftConstraint?.constant = strongSelf.view.bounds.width / 2.0 - sumLabelWidth / 2.0
            strongSelf.sumTopConstraint?.constant = 0.0

            strongSelf.sumBtcLabel?.alpha = 0.0
            strongSelf.sumBtcLeftConstraint?.constant = strongSelf.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7

            strongSelf.sumTitleLabel?.alpha = 0.0
            strongSelf.sumTitleLeftConstraint?.constant = strongSelf.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7

            strongSelf.contactsComponent?.alpha = 0.0
            strongSelf.contactsComponentTopConstraint?.constant = 56.0

            strongSelf.cardOffsetConstraint?.constant = -60

        case .closed:
            strongSelf.sumLabel?.transform = .identity
            strongSelf.sumLeftConstraint?.constant = 16.0
            strongSelf.sumTopConstraint?.constant = 55.0

            strongSelf.sumBtcLabel?.alpha = 1.0
            strongSelf.sumBtcLeftConstraint?.constant = 16.0

            strongSelf.sumTitleLabel?.alpha = 1.0
            strongSelf.sumTitleLeftConstraint?.constant = 16.0

            strongSelf.walletsCollectionViewController?.scrollToTop()

            strongSelf.contactsComponent?.alpha = 1.0
            strongSelf.contactsComponentTopConstraint?.constant = 16.0

            strongSelf.cardOffsetConstraint?.constant = strongSelf.cardViewInitialOffset
        }
        strongSelf.view.layoutIfNeeded()
    }

    // MARK: - Outlets

    @IBOutlet var contactsComponent: ContactsHorizontalComponent?
    @IBOutlet var contactsComponentTopConstraint: NSLayoutConstraint?
    
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

    private var cardViewInitialOffset: CGFloat = 0

    // MARK: - Data

    private var totalBalance: BalanceData?
    private var contactsData: [ContactData] = []

    private var isContactsLoading: Bool = false

    // MARK: - UIViewController Lifecycle

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupDefaultStyle()

        isKeyboardHidesOnTap = true

        contactsData = contactsManager?.contacts ?? []

        if !contactsData.isEmpty {
            self.contactsComponent?.delegate = self
            self.contactsComponent?.contactsCollectionView?.endLoading()
            self.contactsComponent?.prepare(contacts: contactsData)
            self.floatingViewInitialOffset = 350

        } else {
            self.contactsComponent?.contactsCollectionView?.endLoading()
            self.floatingViewInitialOffset = 200

            if self.currentState == .closed {
                self.set(state: .closed)
            }
        }

        switch UIScreen.main.type {
        case .small, .extraSmall:
            detailViewHeight?.constant = 515.0
        case .medium:
            detailViewHeight?.constant = 600.0
        case .extra:
            detailViewHeight?.constant = 691.0
        case .plus:
            detailViewHeight?.constant = 675.0
        case .extraLarge:
            detailViewHeight?.constant = 775.0
        case .unknown:
            fatalError()
        }

        cardViewInitialOffset = cardOffsetConstraint?.constant ?? 0

        detailGestureView?.addGestureRecognizer(floatingPanGestureRecognizer)
        detailTopGestureView?.addGestureRecognizer(floatingPanGestureRecognizer)

        walletsContainerView?.isUserInteractionEnabled = true

        if let embeded = walletsCollectionViewController {
            walletsContainerView?.set(viewController: embeded, owner: self)
            walletsCollectionViewController?.delegate = self
        }

        view.clipsToBounds = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let detailTopView = detailTopGestureView {
            let point = CGPoint(x: detailTopView.bounds.width / 2.0, y: detailTopView.bounds.height / 4.0)
            DrawingHelper.drawIndicator(in: detailTopView, center: point)
        }
    }

    // MARK: - Screen Style

    private func setupStyle() {
        floatingView?.cornerRadius = 16.0
        floatingView?.clipsToBounds = true

        floatingView?.backgroundColor = .white
        detailGestureView?.backgroundColor = .clear

        detailTitleLabel?.textColor = .darkIndigo
        detailTitleLabel?.text = "My accounts"

        sumTitleLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        sumTitleLabel?.textColor = .skyBlue
        sumTitleLabel?.text = "Total balance"

        var sumSymbolFont: UIFont = UIFont()
        var sumMainFont: UIFont = UIFont()

        switch UIScreen.main.type {
        case .extraSmall, .small:
            sumSymbolFont = UIFont.walletFont(ofSize: 28.0, weight: .medium)
            sumMainFont = UIFont.walletFont(ofSize: 28.0, weight: .regular)
        case .medium, .extra, .extraLarge, .plus:
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

        let insets = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        walletsCollectionViewController?.contentInsets = insets
    }

    private func setupTotalBalanceLabel(text: String, primaryStyleRange: CountableRange<Int>, fractionStyleRange: CountableRange<Int>) {

        var sumSymbolFont: UIFont = UIFont()
        var sumMainFont: UIFont = UIFont()

        switch UIScreen.main.type {
        case .extraSmall, .small:
            sumSymbolFont = UIFont.walletFont(ofSize: 28.0, weight: .regular)
            sumMainFont = UIFont.walletFont(ofSize: 28.0, weight: .medium)
        case .medium, .extra, .extraLarge, .plus:
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

        if currentState == .open, !isAnimationInProgress {
            sumLabel?.sizeToFit()

            let sumLabelWidth = sumLabel?.bounds.width ?? 0.0
            sumLeftConstraint?.constant = self.view.bounds.width / 2.0 - sumLabelWidth / 2.0
            sumTitleLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7
            sumBtcLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7
        }
    }

    // MARK: - HomeController

    func performSendFromWallet(index: Int, wallets: [WalletData], phone: String, recipient: FormattedContactData? = nil) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        self.onSendFromWallet?(index, wallets, recipient, phone)
    }

    func performDepositFromWallet(index: Int, wallets: [WalletData], phone: String) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        self.onDepositToWallet?(index, wallets, phone)
    }

    func performWalletDetails(index: Int, wallets: [WalletData], phone: String) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange, .timingFunction(.easeInOut)]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        self.onWalletDetails?(index, wallets, phone)
    }

    // MARK: - AdvancedTransitionDelegate

    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }

        walletsCollectionViewController?.prepareToAnimation(cellIndex: index)
    }

    // MARK: - SendMoneyViewControllerDelegate

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        loadData()

        walletsCollectionViewController?.reload()
    }

    // MARK: - Load data

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


    // MARK: - WalletsViewControllerDelegate

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController) {
        loadData()
    }

    func walletsViewControllerScrollingEvent(_ walletsViewController: WalletsViewController, panGestureRecognizer: UIPanGestureRecognizer, offset: CGPoint) {
        switch currentState {
        case .closed:
            switch panGestureRecognizer.state {
            case .began:
                // translate wallets collections view gesture recognizer to floating handler
                floatingPanGestureEvent(recognizer: panGestureRecognizer)
            case .changed:
                // holds wallets collection view offset stable while floating view moves
                let point = CGPoint(x: 0.0, y: -walletsViewController.collectionView.contentInset.top)
                walletsViewController.collectionView.contentOffset = point

                // translate wallets collections view gesture recognizer to floating handler
                floatingPanGestureEvent(recognizer: panGestureRecognizer)
            case .ended:
                // holds wallets collection view offset stable while floating view moves
                let point = CGPoint(x: 0.0, y: -walletsViewController.collectionView.contentInset.top)
                walletsViewController.collectionView.contentOffset = point

                // translate wallets collections view gesture recognizer to floating handler
                floatingPanGestureEvent(recognizer: panGestureRecognizer)
            default:
                ()
            }
        default:
            ()
        }
    }

    // MARK: - ContactsHorizontalComponentDelegate

    func contactsHorizontalComponent(_ contactsHorizontalComponent: ContactsHorizontalComponent, itemWasTapped contactData: ContactData) {
        contactsHorizontalComponent.isUserInteractionEnabled = false

        dismissKeyboard {
            [weak self] in

            contactData.toFormatted {
                formatted in

                contactsHorizontalComponent.isUserInteractionEnabled = true

                if let formatted = formatted {
                    self?.walletsCollectionViewController?.sendTo(contact: formatted)
                }
            }
        }
    }

    // MARK: - FloatingViewController

    override func stateChangingBegin(_ state: FloatingViewController.State) {
        super.stateChangingBegin(state)

        if let embeded = walletsCollectionViewController, embeded.isTopExpanded {
            walletsCollectionViewController?.scrollToTop()
        }

        if state == .closed {
            walletsCollectionViewController?.isScrollEnabled = false
        }

        contactsComponent?.isUserInteractionEnabled = false
    }

    override func stateDidChange(_ state: FloatingViewController.State) {
        super.stateDidChange(state)

        walletsCollectionViewController?.isScrollEnabled = true
        contactsComponent?.isUserInteractionEnabled = true

        viewsAnimationBlock(state)
    }

    override func createTransitionAnimatorsIfNeeded(to state: FloatingViewController.State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        guard let transitionAnimator = super.createTransitionAnimatorsIfNeeded(to: state, duration: duration).first else {
            fatalError()
        }

        self.contactsComponent?.searchTextField?.resignFirstResponder()

        // an animator for the transition
        transitionAnimator.addAnimations {
            self.viewsAnimationBlock(state)
        }

        return [transitionAnimator]
    }
}
