//
//  DepositMoneyMethodComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

enum DepositMoneyMethod {
    case address
    case card
}

protocol DepositMoneyMethodComponentDelegate: class {

    func depositMoneyMethodSelected(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, method: DepositMoneyMethod)

    func depositMoneyMethodWalletChanged(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, toIndex: Int, wallets: [WalletData])

    func depositMoneyMethodCardChanged(_ depositMoneyMethodSelected: DepositMoneyMethodComponent, toCardId: String)
}

class DepositMoneyMethodComponent: Component, SegmentedControlComponentDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: DepositMoneyMethodComponentDelegate?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var segmentedControlComponent: SegmentedControlComponent?
    @IBOutlet private var walletsCollectionView: UICollectionView?

    private var phone: String?
    private var wallets: [WalletData] = []
    private var currentIndex: Int?

    // MARK: - Component

    override func initFromNib() {
        super.initFromNib()

        segmentedControlComponent?.delegate = self

        segmentedControlComponent?.alignment = .left
        segmentedControlComponent?.segmentsHorizontalMargin = 15.0
        segmentedControlComponent?.segmentsHorizontalSpacing = 5.0

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "linkTo"), title: "Address", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .lightblue)

        segmentedControlComponent?.addSegment(icon: #imageLiteral(resourceName: "card"), title: "Card", iconTintColor: .paleOliveGreen, selectedTintColor: .white, backColor: .paleOliveGreen).isEnabled = false

        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textColor = .darkIndigo
        titleLabel?.text = "From"

        walletsCollectionView?.register(WalletSmallItemComponent.self , forCellWithReuseIdentifier: "WalletSmallItemComponent")
        walletsCollectionView?.dataSource = self
        walletsCollectionView?.delegate = self
        walletsCollectionView?.isPagingEnabled = true
        walletsCollectionView?.backgroundColor = .clear
        walletsCollectionView?.clipsToBounds = false
    }

    override func setupStyle() {
        super.setupStyle()

        self.backgroundColor = .white
    }

    // MARK: - Public methods

    func prepare(wallets: [WalletData], currentIndex: Int, phone: String) {
        self.phone = phone
        self.wallets = wallets
        self.currentIndex = currentIndex

        walletsCollectionView?.reloadData()
        walletsCollectionView?.performBatchUpdates(nil) {
            [weak self] _ in

            self?.scrollToCurrentWallet()
        }

        delegate?.depositMoneyMethodSelected(self, method: .address)
    }

    // MARK: - Private methods

    private func scrollToCurrentWallet() {
        guard let index = currentIndex else {
            return
        }

        let indexPath = IndexPath(item: 0, section: index)

        walletsCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    // MARK: - UICollectionViewDataSource

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

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    // MARK: - UIScrollViewDelegate

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

        delegate?.depositMoneyMethodWalletChanged(self, toIndex: indexPath.section, wallets: wallets)
    }

    // MARK: - SegmentedControlComponentDelegate

    func segmentedControlComponent(_ segmentedControlComponent: SegmentedControlComponent, currentIndexChangedTo index: Int) {
        //...
    }
}

