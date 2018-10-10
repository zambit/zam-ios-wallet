//
//  SendMoneyViewController.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

protocol SendMoneyViewControllerDelegate: class {

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController)
}

class SendMoneyViewController: AvoidingViewController, WalletsCollectionComponentDelegate, SendMoneyComponentDelegate, TransactionDetailViewControllerDelegate, QRCodeScannerViewControllerDelegate {

    weak var delegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var onSend: ((SendingData) -> Void)?
    var onQRScanner: (() -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var walletsCollectionComponent: WalletsCollectionComponent?
    @IBOutlet private var sendMoneyComponent: SendMoneyComponent?

    private var recipient: FormattedContactData?
    private var phone: String?
    private var wallets: [WalletData] = []
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

        walletNavigationController?.custom.addBackButton(for: self, target: self, action: #selector(backButtonTouchUpInsideEvent(_:)))
    }

    func prepare(wallets: [WalletData], currentIndex: Int, recipient: FormattedContactData? = nil, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex

        self.recipient = recipient

        let itemsData = wallets.map { WalletItemData(data: $0, phoneNumber: phone) }
        walletsCollectionComponent?.custom.prepare(cards: itemsData, current: currentIndex)

        sendMoneyComponent?.prepare(recipient: recipient, coinType: wallets[currentIndex].coin, walletId: wallets[currentIndex].id)
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

            self?.wallets[currentIndex] = wallet
            let itemData = WalletItemData(data: wallet, phoneNumber: phone)
            currentCell.configure(with: itemData)
        }.catch {
            error in

            Crashlytics.sharedInstance().recordError(error)
        }
    }

    // MARK: - WalletsCollectionComponentDelegate

    func walletsCollectionComponentCurrentIndexChanged(_ walletsCollectionComponent: WalletsCollectionComponent, to index: Int) {
        self.sendMoneyComponent?.prepare(coinType: wallets[index].coin, walletId: wallets[index].id)
    }

    // MARK: - SendMoneyComponentDelegate

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, output: SendingData) {
        dismissKeyboard {
            [weak self] in
            
            self?.onSend?(output)
        }
    }

    // MARK: - TransactionDetailViewControllerDelegate

    func transactionDetailViewControllerSendingProceedWithSuccess(_ transactionDetailViewController: TransactionDetailViewController) {
        updateDataForCurrentWallet()
        delegate?.sendMoneyViewControllerSendingProceedWithSuccess(self)
    }

    // MARK: - QRCodeScannerViewControllerDelegate

    func qrCodeScannerViewController(_ qrCodeScannerViewController: QRCodeScannerViewController, didFindCode code: String) {
        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(address: code, coinType: wallets[index].coin, walletId: wallets[index].id)
        }
    }

    func qrCodeScannerViewControllerDidntFindCode(_ qrCodeScannerViewController: QRCodeScannerViewController) {
        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(address: "", coinType: wallets[index].coin, walletId: wallets[index].id)
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
