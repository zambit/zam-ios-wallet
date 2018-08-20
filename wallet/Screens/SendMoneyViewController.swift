//
//  SendMoneyViewController.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SendMoneyViewController: KeyboardBehaviorFollowingViewController, SendMoneyComponentDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var onSend: ((SendMoneyData) -> Void)?

    @IBOutlet var sendMoneyComponent: SendMoneyComponent?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var walletsCollectionView: UICollectionView?

    private var phone: String?
    private var wallets: [WalletData] = []
    private var currentIndex: Int? {
        didSet {
            if let currentIndex = currentIndex {
                let indexPath = IndexPath(item: 0, section: currentIndex)
                walletsCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }

    override var fastenOffset: CGFloat {
        return 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let index = currentIndex
        self.currentIndex = index

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardOnTap()
        
        view.applyDefaultGradientHorizontally()

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

        let index = currentIndex
        self.currentIndex = index

        if let index = currentIndex, wallets.count > index {
            sendMoneyComponent?.prepare(coinType: wallets[index].coin, walletId: wallets[index].id)
        }

        walletsCollectionView?.layoutIfNeeded()
        walletsCollectionView?.reloadData()

        sendMoneyComponent?.delegate = self
    }

    func prepare(wallets: [WalletData], currentIndex: Int, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex

        walletsCollectionView?.reloadData()
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

        let wallet = wallets[indexPath.section]
        self.sendMoneyComponent?.prepare(coinType: wallet.coin, walletId: wallet.id)
    }

    func sendMoneyComponentRequestSending(_ sendMoneyComponent: SendMoneyComponent, sendMoneyData: SendMoneyData) {
        onSend?(sendMoneyData)
    }
}
