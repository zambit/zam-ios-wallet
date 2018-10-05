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

class SendMoneyViewController: AvoidingViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SendMoneyComponentDelegate, TransactionDetailViewControllerDelegate, QRCodeScannerViewControllerDelegate {

    weak var delegate: SendMoneyViewControllerDelegate?
    weak var advancedTransitionDelegate: AdvancedTransitionDelegate?

    var onSend: ((SendingData) -> Void)?
    var onQRScanner: (() -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    @IBOutlet var sendMoneyComponent: SendMoneyComponent?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var walletsCollectionView: UICollectionView?

    private var recipient: FormattedContactData?
    private var phone: String?
    private var wallets: [WalletData] = []
    private var currentIndex: Int?

    override var fastenInitialOffset: CGFloat {
        return 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollToCurrentWallet()

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

                self?.walletsCollectionView?.visibleCells.first?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self?.walletsCollectionView?.alpha = 0.0
                self?.titleLabel?.alpha = 0.0
            }

            disappearingAnimationBlock = {
                [weak self] in

                self?.walletsCollectionView?.visibleCells.first?.transform = .identity
                self?.walletsCollectionView?.alpha = 1.0
                self?.titleLabel?.alpha = 1.0
            }
        }

        walletsCollectionView?.register(WalletSmallItemComponent.self , forCellWithReuseIdentifier: "WalletSmallItemComponent")
        walletsCollectionView?.dataSource = self
        walletsCollectionView?.delegate = self
        walletsCollectionView?.isPagingEnabled = true
        walletsCollectionView?.backgroundColor = .clear
        walletsCollectionView?.clipsToBounds = false

        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .left
        titleLabel?.text = "From"

        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(recipient: recipient, coinType: wallets[index].coin, walletId: wallets[index].id)
        }

        walletsCollectionView?.layoutIfNeeded()
        walletsCollectionView?.reloadData()

        sendMoneyComponent?.onQRCodeScanning = onQRScanner
        sendMoneyComponent?.delegate = self

        hero.isEnabled = true

        migratingNavigationController?.custom.addBackButton(for: self, target: self, action: #selector(backButtonTouchUpInsideEvent(_:)))
    }

    func prepare(wallets: [WalletData], currentIndex: Int, recipient: FormattedContactData? = nil, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex

        self.recipient = recipient

        walletsCollectionView?.reloadData()
    }

    private func updateDataForCurrentWallet() {
        guard
            let token = userManager?.getToken(),
            let phone = userManager?.getPhoneNumber(),
            let index = currentIndex,
            let sectionsCount = walletsCollectionView?.numberOfSections,
            sectionsCount > index else {
                return
        }

        let oldWallet = wallets[index]
        let indexPath = IndexPath(item: 0, section: index)

        guard let walletCell = walletsCollectionView?.cellForItem(at: indexPath) as? WalletSmallItemComponent else {
            return
        }

        userAPI?.getWalletInfo(token: token, walletId: oldWallet.id).done {
            [weak self]
            wallet in

            self?.wallets[index] = wallet
            walletCell.configure(image: wallet.coin.image, coinName: wallet.coin.name, coinAddit: wallet.coin.short, phoneNumber: phone, balance: wallet.balance.formatted(currency: .original), fiatBalance: wallet.balance.description(currency: .usd))
        }.catch {
            error in
            
            Crashlytics.sharedInstance().recordError(error)
        }
    }

    private func scrollToCurrentWallet() {
        guard
            let index = currentIndex,
            let sectionsCount = walletsCollectionView?.numberOfSections,
            sectionsCount > index else {
            return
        }

        let indexPath = IndexPath(item: 0, section: index)

        walletsCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return wallets.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletSmallItemComponent", for: indexPath)

        guard let cell = _cell as? WalletSmallItemComponent else {
            fatalError()
        }

        guard let phone = phone, indexPath.section < wallets.count else {
            return UICollectionViewCell()
        }

        if let currentIndex = currentIndex, indexPath.section == currentIndex {
            cell.setTargetToAnimation()
        }

        let wallet = wallets[indexPath.section]
        cell.configure(image: wallet.coin.image, coinName: wallet.coin.name, coinAddit: wallet.coin.short, phoneNumber: phone, balance: wallet.balance.formatted(currency: .original), fiatBalance: wallet.balance.description(currency: .usd))
        cell.setupPages(currentIndex: indexPath.section, count: wallets.count)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = walletsCollectionView else {
            return
        }

        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint), wallets.count > indexPath.section else {
            return
        }

        self.currentIndex = indexPath.section
        let wallet = wallets[indexPath.section]
        self.sendMoneyComponent?.prepare(coinType: wallet.coin, walletId: wallet.id)
    }

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, output: SendingData) {
        dismissKeyboard {
            [weak self] in
            
            self?.onSend?(output)
        }
    }

    func transactionDetailViewControllerSendingProceedWithSuccess(_ transactionDetailViewController: TransactionDetailViewController) {
        updateDataForCurrentWallet()
        delegate?.sendMoneyViewControllerSendingProceedWithSuccess(self)
    }

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

    @objc
    private func backButtonTouchUpInsideEvent(_ sender: Any) {
        if let index = currentIndex {

            walletsCollectionView?.visibleCells.compactMap {
                return $0 as? WalletSmallItemComponent
            }.forEach {
                $0.removeTargetToAnimation()
            }

            (walletsCollectionView?.cellForItem(at: IndexPath(item: 0, section: index)) as? WalletSmallItemComponent)?.setTargetToAnimation()
            
            advancedTransitionDelegate?.advancedTransitionWillBegin(from: self, params: ["walletIndex": index])
        }

        migratingNavigationController?.popViewController(animated: true)
    }
}
