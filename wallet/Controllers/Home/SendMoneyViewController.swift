//
//  SendMoneyViewController.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import Crashlytics

/**
 Protocol providing sending money completion callbacks.
 */
protocol SendMoneyViewControllerDelegate: class {

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController)

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int)
}

extension SendMoneyViewControllerDelegate {

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {}

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController, updated data: Wallet, index: Int) {}
}

/**
 Send money screen. Determines sending money details before send.
 */
class SendMoneyViewController: AvoidingViewController {

    weak var delegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var onSend: ((SendingData) -> Void)?
    var onQRScanner: (() -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?
    var priceAPI: PriceAPI?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var walletsCollectionComponent: WalletsCollectionComponent?
    @IBOutlet private var sendMoneyComponent: SendMoneyComponent?

    private var recipient: FormattedContact?
    private var phone: String?
    private var wallets: [Wallet] = []
    private var currentIndex: Int?

    override var fastenInitialOffset: CGFloat {
        return 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hero.isEnabled = true
        self.sendMoneyComponent?.contentView.hero.id = "floatingView"

        switch UIScreen.main.type {
        case .small, .extraSmall:
            sendMoneyComponent?.prepare(preset: .superCompact)
        case .medium:
            sendMoneyComponent?.prepare(preset: .compact)
        case .plus, .extra:
            sendMoneyComponent?.prepare(preset: .default)
        case .extraLarge:
            sendMoneyComponent?.prepare(preset: .large)
        case .unknown:
            fatalError()
        }

        isKeyboardHidesOnTap = true
        
        view.applyDefaultGradientHorizontally()

        switch UIScreen.main.type {
        case .extraLarge:
            break
        case .unknown:
            fatalError()
        default:
            appearingAnimationBlock = {
                [weak self] in
                self?.walletsCollectionComponent?.currentItem?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self?.walletsCollectionComponent?.alpha = 0.0
                self?.titleLabel?.alpha = 0.0
            }
            disappearingAnimationBlock = {
                [weak self] in
                self?.walletsCollectionComponent?.currentItem?.transform = .identity
                self?.walletsCollectionComponent?.alpha = 1.0
                self?.titleLabel?.alpha = 1.0
            }
        }

        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .left
        titleLabel?.text = "From"

        if let currentIndex = currentIndex, let phone = phone {
            self.prepare(wallets: wallets, currentIndex: currentIndex, recipient: recipient, phone: phone)
        }

        sendMoneyComponent?.onQRCodeScanning = onQRScanner
        sendMoneyComponent?.delegate = self

        walletsCollectionComponent?.delegate = self

        walletNavigationController?.custom.addBackButton(in: self, target: self, action: #selector(backButtonTouchUpInsideEvent(_:)))
    }

    func prepare(wallets: [Wallet], currentIndex: Int, recipient: FormattedContact? = nil, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex

        self.recipient = recipient

        let itemsData = wallets.map { WalletItemData(data: $0, phoneNumber: phone) }
        walletsCollectionComponent?.custom.prepare(cards: itemsData, current: currentIndex)

        sendMoneyComponent?.prepare(recipient: recipient, coinType: wallets[currentIndex].coin, fiatType: .standard, walletId: wallets[currentIndex].id, walletCoinValue: wallets[currentIndex].balance.original, walletFiatValue: wallets[currentIndex].balance.usd, coinPrice: nil)

        updatePriceForCurrentCoin {
            [weak self]
            price in

            self?.sendMoneyComponent?.prepare(coinPrice: price)
        }
    }

    // MARK: - Back button custom event

    @objc
    private func backButtonTouchUpInsideEvent(_ sender: Any) {
        if let index = currentIndex {
            walletsCollectionComponent?.custom.prepareForAnimation()

            advancedTransitionDelegate?.advancedTransitionWillBegin(from: self, params: ["walletIndex": index])
        }

        dismissKeyboard {
            [weak self] in
            
            self?.walletNavigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Extensions

/**
 Extension implements `QRCodeScannerViewControllerDelegate` protocol. Provides callbacks from QRCodeScanner screen.
 */
extension SendMoneyViewController: QRCodeScannerViewControllerDelegate {

    /**
     Notifies about finding qr code and scanning data from it.
     */
    func qrCodeScannerViewController(_ qrCodeScannerViewController: QRCodeScannerViewController, didFindCode code: String) {
        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(address: code, coinType: wallets[index].coin, fiatType: .standard, walletId: wallets[index].id, walletCoinValue: wallets[index].balance.original, walletFiatValue: wallets[index].balance.usd)
        }
    }

    /**
     Notifies about failing finding qr code.
     */
    func qrCodeScannerViewControllerDidntFindCode(_ qrCodeScannerViewController: QRCodeScannerViewController) {
        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(address: "", coinType: wallets[index].coin, fiatType: .standard, walletId: wallets[index].id, walletCoinValue: wallets[index].balance.original, walletFiatValue: wallets[index].balance.usd)
        }
    }
}

/**
 Extension implements `TransactionDetailViewControllerDelegate` protocol. Provides callbacks from TransactionDetails screen.
 */
extension SendMoneyViewController: TransactionDetailViewControllerDelegate {

    /**
     Notifies that sending transaction was done and balances needs to be reloaded.
     */
    func transactionDetailViewControllerSendingProceedWithSuccess(_ transactionDetailViewController: TransactionDetailViewController) {
        updateDataForCurrentWallet()
        delegate?.sendMoneyViewControllerSendingProceedWithSuccess(self)
    }

    private func updateDataForCurrentWallet() {
        guard
            let token = userManager?.getToken(),
            let phone = userManager?.getPhoneNumber(),
            let currentIndex = walletsCollectionComponent?.currentIndex,
            let currentCell = walletsCollectionComponent?.currentItem
            else {
                return
        }

        let wallet = wallets[currentIndex]

        userAPI?.getWalletInfo(token: token, walletId: wallet.id).done {
            [weak self]
            wallet in

            guard let strongSelf = self else {
                return
            }

            self?.wallets[currentIndex] = wallet
            let itemData = WalletItemData(data: wallet, phoneNumber: phone)
            currentCell.configure(with: itemData)

            self?.delegate?.sendMoneyViewControllerSendingProceedWithSuccess(strongSelf, updated: wallet, index: currentIndex)
        }.catch {
            error in

            Crashlytics.sharedInstance().recordError(error)
        }
    }
}

/**
 Extension implements `SendMoneyComponentDelegate` protocol. Provides callbacks from SendMoney component that controls entering amount, participant and tapping send button.
 */
extension SendMoneyViewController: SendMoneyComponentDelegate {

    /**
     Notifies that send money button was tapped for given sending output data.
     */
    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, output: SendingData) {
        dismissKeyboard {
            [weak self] in

            self?.onSend?(output)
        }
    }
}

/**
 Extension implements `WalletsCollectionComponentDelegate` protocol. Provides callbacks from top wallets horizontal collection - WalletsCollection component.
 */
extension SendMoneyViewController: WalletsCollectionComponentDelegate {

    /**
     Notifies about changing current wallet.
     */
    func walletsCollectionComponentCurrentIndexChanged(_ walletsCollectionComponent: WalletsCollectionComponent, to index: Int) {
        self.currentIndex = index
        self.sendMoneyComponent?.prepare(coinType: wallets[index].coin, fiatType: .standard, walletId: wallets[index].id, walletCoinValue: wallets[index].balance.original, walletFiatValue: wallets[index].balance.usd, coinPrice: nil)

        updatePriceForCurrentCoin {
            [weak self]
            price in

            self?.sendMoneyComponent?.prepare(coinPrice: price)
        }
    }

    private func updatePriceForCurrentCoin(_ completion: @escaping (CoinPrice) -> Void) {
        guard let currentIndex = walletsCollectionComponent?.currentIndex else {
            return
        }

        let wallet = wallets[currentIndex]

        if wallet.coin == .zam {
            let price = CoinPrice(coin: .zam, fiat: .usd, price: Decimal(0.02), marketCap: Decimal(0.0), volumeDay: Decimal(0.0), volume24h: Decimal(0.0), changePct24h: Decimal(0.0), change24h: Decimal(0.0), openDay: Decimal(0.0), highDay: Decimal(0.0), lowDay: Decimal(0.0), open24h: Decimal(0.0), high24h: Decimal(0.0), low24h: Decimal(0.0), supply: Decimal(0.0))
            return completion(price)
        }

        priceAPI?.getCoinDetailPrice(coin: wallet.coin, convertingTo: .usd).done {
            price in
            completion(price)
        }.catch {
            error in
            Crashlytics.sharedInstance().recordError(error)
        }
    }
}
