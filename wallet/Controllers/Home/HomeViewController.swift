//
//  HomeViewController.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Crashlytics

/**
 Protocol that provides interface to call some methods of home screen.
 */
protocol HomeController: class {

    func performSendFromWallet(index: Int, wallets: [Wallet], phone: String, recipient: FormattedContact?)

    func performDepositFromWallet(index: Int, wallets: [Wallet], phone: String)

    func performWalletDetails(index: Int, wallets: [Wallet], phone: String)
}

/**
 Home screen that have floating view with embeded view controller.
 */
class HomeViewController: FloatingViewController {

    var contactsManager: UserContactsManager?
    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    var onSendFromWallet: ((_ index: Int, _ wallets: [Wallet], _ recipient: FormattedContact?, _ phone: String) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?
    var onWalletDetails: ((_ index: Int, _ wallets: [Wallet], _ phone: String) -> Void)?

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

    private var totalBalance: Balance?
    private var contactsData: [Contact] = []

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

        let insets = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        walletsCollectionViewController?.contentInsets = insets

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
        detailTitleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        detailTitleLabel?.text = "My accounts"

        sumTitleLabel?.font = UIFont.walletFont(ofSize: 12.0, weight: .regular)
        sumTitleLabel?.textColor = .skyBlue
        sumTitleLabel?.text = "Total balance"

        setupTotalBalanceLabel(text: "$ 0.00", primaryStyleRange:  2..<4, fractionStyleRange: 4..<6)

        sumBtcLabel?.font = UIFont.walletFont(ofSize: 14.0, weight: .regular)
        sumBtcLabel?.textColor = .skyBlue
        sumBtcLabel?.text = "0.0 BTC"

        detailTopGestureView?.applyGradient(colors: [.white, UIColor.white.withAlphaComponent(0.7), UIColor.white.withAlphaComponent(0.0)], locations: [0.0, 0.75, 1.0])
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

        if currentState == .open, !isAnimationInProgress {
            sumLabel?.sizeToFit()

            let sumLabelWidth = sumLabel?.bounds.width ?? 0.0
            sumLeftConstraint?.constant = self.view.bounds.width / 2.0 - sumLabelWidth / 2.0
            sumTitleLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7
            sumBtcLeftConstraint?.constant = self.view.bounds.width / 2.0 - (sumLabelWidth / 2.0) * 0.7
        }
    }

    // MARK: - Load data

    private func loadData() {
        guard let token = userManager?.getToken() else {
            return
        }

        sumLabel?.endLoading()
        sumLabel?.beginLoading()

        userAPI?.getUserInfo(token: token, coin: nil).done {
            [weak self]
            info in

            guard let totalBalance = info.balances.first else {
                return
            }

            self?.totalBalance = totalBalance

            performWithDelay {
                self?.updateLabels()
            }
        }.catch {
            [weak self]
            error in

            Crashlytics.sharedInstance().recordError(error)

            self?.sumLabel?.endLoading()
        }
    }

    private func updateLabels() {
        sumLabel?.endLoading()

        guard
            let totalBalance = totalBalance,
            let separator = NumberFormatter.amount.decimalSeparator.first else {
            return
        }

        let usdBalance = totalBalance.description(property: .usd) 
        let parts = usdBalance.split(separator: separator)
        guard parts.count == 2 else { return }

        let primary = String(parts[0])
        let fraction = String(parts[1])

        let primaryRange = 2..<primary.count + 1
        let fractionRange = (primary.count + 1)..<(primary.count + 1 + fraction.count)
        setupTotalBalanceLabel(text: usdBalance, primaryStyleRange: primaryRange, fractionStyleRange: fractionRange)

        sumBtcLabel?.text = totalBalance.description(property: .original)
    }

    // MARK: - FloatingViewController

    override func stateChangingBegin(to state: FloatingViewController.State) {
        super.stateChangingBegin(to: state)

        // Scroll wallets to top if moving floating view initiated
        if let embeded = walletsCollectionViewController, embeded.isTopExpanded {
            walletsCollectionViewController?.scrollToTop()
        }

        // Prevent user scrolling during closing animation
        if state == .closed {
            walletsCollectionViewController?.isScrollEnabled = false
        }

        contactsComponent?.isUserInteractionEnabled = false
    }

    override func stateDidChange(_ state: FloatingViewController.State) {
        super.stateDidChange(state)

        walletsCollectionViewController?.isScrollEnabled = true
        contactsComponent?.isUserInteractionEnabled = true

        // Explicity perform setting target values after animation, preventing bug, when sometimes animation breaks and some properties don't reach their target values.
        viewsAnimationBlock(state)
    }

    override func createTransitionAnimatorsIfNeeded(to state: FloatingViewController.State, duration: TimeInterval) -> [UIViewPropertyAnimator] {

        guard let transitionAnimator = super.createTransitionAnimatorsIfNeeded(to: state, duration: duration).first else {
            fatalError()
        }

        self.contactsComponent?.searchTextField?.resignFirstResponder()

        // An animator for the transition
        transitionAnimator.addAnimations {
            self.viewsAnimationBlock(state)
        }

        return [transitionAnimator]
    }
}

// MARK: - Extensions

/**
 Extension implements HomeController protocol. It's interface to use from child view controller in contrainer.
 */
extension HomeViewController: HomeController {

    func performSendFromWallet(index: Int, wallets: [Wallet], phone: String, recipient: FormattedContact? = nil) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        contactsComponent?.searchTextField?.resignFirstResponder()

        onSendFromWallet?(index, wallets, recipient, phone)
    }

    func performDepositFromWallet(index: Int, wallets: [Wallet], phone: String) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        contactsComponent?.searchTextField?.resignFirstResponder()

        onDepositToWallet?(index, wallets, phone)
    }

    func performWalletDetails(index: Int, wallets: [Wallet], phone: String) {
        floatingView?.hero.id = "floatingView"
        floatingView?.hero.modifiers = [.useScaleBasedSizeChange, .timingFunction(.easeInOut)]
        detailTopGestureView?.hero.modifiers = [.fade]
        walletsContainerView?.hero.modifiers = [.fade]

        contactsComponent?.searchTextField?.resignFirstResponder()

        onWalletDetails?(index, wallets, phone)
    }
}

/**
 Extension implements WalletsViewControllerDelegate protocol. It provides callbacks from WalletsViewController screen.
 */
extension HomeViewController: WalletsViewControllerDelegate {

    /**
     Notifies about refreshing.
     */
    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController) {
        loadData()
    }

    /**
     Notifies about changing scrolling offset on WalletsViewController. Translate its scrolling to floating view if needed.
     */
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
}

/**
 Extension implements ContactsHorizontalComponentDelegate protocol. It provides callbacks from contacts horizontal collection component.
 */
extension HomeViewController: ContactsHorizontalComponentDelegate {

    /**
     Notifies that given contact was tapped.
     */
    func contactsHorizontalComponent(_ contactsHorizontalComponent: ContactsHorizontalComponent, itemWasTapped contactData: Contact) {
        contactsHorizontalComponent.isUserInteractionEnabled = false

        dismissKeyboard {
            [weak self] in

            // Convert contact to formatted object for representing converted phone number.
            contactData.toFormatted {
                formatted in

                contactsHorizontalComponent.isUserInteractionEnabled = true

                if let formatted = formatted {
                    self?.walletsCollectionViewController?.sendTo(contact: formatted)
                }
            }
        }
    }
}

/**
 Extension implements SendMoneyViewControllerDelegate protocol. It provides callbacks from SendMoneyViewController screen.
 */
extension HomeViewController: SendMoneyViewControllerDelegate {

    /**
     Notifies that sending transaction was done and balances needs to be reloaded.
     */
    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        loadData()

        walletsCollectionViewController?.reload()
    }
}

/**
 Extension implements AdvancedTransitionDelegate protocol. It provides transitions callbacks.
 */
extension HomeViewController: AdvancedTransitionDelegate {

    /**
     Ask viewController for preparing views to upcoming transition.
     */
    func advancedTransitionWillBegin(from viewController: FlowViewController, params: [String : Any]) {
        guard let index = params["walletIndex"] as? Int else {
            return
        }

        walletsCollectionViewController?.prepareToAnimation(cellIndex: index)
    }
}
