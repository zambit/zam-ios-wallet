//
//  WalletsViewController.swift
//  wallet
//
//  Created by  me on 07/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

typealias WalletsCollectionViewController = (UIViewController & WalletsCollection)

/**
 Protocol that provides interface to control wallets collection from it's owner screen.
 */
protocol WalletsCollection {

    var delegate: WalletsViewControllerDelegate? { get set }

    var owner: ScreenWalletNavigable? { get set }

    var isTopExpanded: Bool { get }

    func setContentInsets(_ insets: UIEdgeInsets)

    func scrollToTop()

    func sendWithContact(_ contact: FormattedContactData)
}

protocol WalletsViewControllerDelegate: class {

    func walletsViewControllerCallsUpdateData(_ walletsViewController: WalletsViewController)

    func walletsViewControllerScrollingEvent(_ walletsViewController: WalletsViewController, panGestureRecognizer: UIPanGestureRecognizer, offset: CGPoint)
}

class WalletsViewController: FlowCollectionViewController, UICollectionViewDelegateFlowLayout, SendMoneyViewControllerDelegate, WalletsCollection {

    private weak var _owner: ScreenWalletNavigable?
    private weak var _delegate: WalletsViewControllerDelegate?

    var onSendFromWallet: ((_ index: Int, _ wallets: [WalletData], _ recipient: FormattedContactData?, _ phone: String, _ owner: ScreenWalletNavigable) -> Void)?
    var onDepositToWallet: ((_ index: Int, _ wallets: [WalletData], _ phone: String, _ owner: ScreenWalletNavigable) -> Void)?

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    private var wallets: [WalletData] = []
    private var phone: String?

    private var refreshControl: UIRefreshControl?

    private var savedWalletsContentOffset: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        collectionView?.backgroundColor = .clear

        collectionView?.register(WalletItemComponent.self , forCellWithReuseIdentifier: "WalletItemComponent")
        collectionView?.delegate = self
        collectionView?.dataSource = self

        phone = userManager?.getPhoneNumber()

        loadData(self)

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChangedEvent(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -2
        collectionView?.insertSubview(refreshControl!, at: 0)

        collectionView?.panGestureRecognizer.addTarget(self, action: #selector(collectionViewPanGestureEvent(recognizer:)))
    }

    // MARK: - WalletsCollection

    var delegate: WalletsViewControllerDelegate? {
        get {
            return _delegate
        }

        set {
            _delegate = newValue
        }
    }

    var owner: ScreenWalletNavigable? {
        get {
            return _owner
        }

        set {
            _owner = newValue
        }
    }

    var isTopExpanded: Bool {
        return collectionView.contentOffset.y < -collectionView.contentInset.top
    }

    func setContentInsets(_ insets: UIEdgeInsets) {
        collectionView.contentInset = insets
    }

    func scrollToTop() {
        let newContentOffset = CGPoint(x: 0.0, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(newContentOffset, animated: false)
    }

    func sendWithContact(_ contact: FormattedContactData) {
        guard let phone = phone, let owner = _owner else {
            return
        }

        onSendFromWallet?(0, wallets, contact, phone, owner)
    }

    // MARK: - UIPanGestureRecognizer

    @objc
    func collectionViewPanGestureEvent(recognizer: UIPanGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }

        let translation = recognizer.translation(in: collectionView)
        let clearOffset = CGPoint(x: translation.x, y: translation.y + collectionView.contentInset.top - collectionView.contentInset.bottom)

        _delegate?.walletsViewControllerScrollingEvent(self, panGestureRecognizer: recognizer, offset: clearOffset)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletItemComponent", for: indexPath)

        guard let cell = _cell as? WalletItemComponent else {
            fatalError()
        }

        guard let phone = phone else {
            fatalError()
        }

        let wallet = wallets[indexPath.item]
        cell.configure(image: wallet.coin.image, coinName: wallet.coin.name, coinAddit: wallet.coin.short, phoneNumber: phone, balance: wallet.balance.formatted(currency: .original), fiatBalance: wallet.balance.description(currency: .usd))
        cell.onSendButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.onSendFromWallet?(indexPath.item, strongSelf.wallets, nil, phone, owner)
        }
        cell.onDepositButtonTap = {
            [weak self] in

            guard let strongSelf = self, let owner = strongSelf._owner else {
                return
            }

            strongSelf.onDepositToWallet?(indexPath.item, strongSelf.wallets, phone, owner)
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.width, height: 134.0)
    }

    // MARK: - SendMoneyViewControllerDelegate

    func sendMoneyViewControllerSendingProceedWithSuccess(_ sendMoneyViewController: SendMoneyViewController) {
        refreshControlValueChangedEvent(self)
    }

    @objc
    private func refreshControlValueChangedEvent(_ sender: Any) {
        _delegate?.walletsViewControllerCallsUpdateData(self)
        loadData(sender)
    }

    private func loadData(_ sender: Any) {
        guard let token = userManager?.getToken() else {
            return
        }

        userAPI?.getWallets(token: token).done {
            [weak self]
            wallets in

            self?.wallets = wallets
            self?.collectionView?.reloadData()
            self?.refreshControl?.endRefreshing()
        }.catch {
            [weak self]
            error in

            self?.refreshControl?.endRefreshing()
        }
    }
}
