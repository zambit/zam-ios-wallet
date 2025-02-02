//
//  TransactionsCoinFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsCoinFilterComponent: CellComponent, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var onFilterChanged: (([CoinType]) -> Void)?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var coinsButtonsCollectionView: UICollectionView?
    @IBOutlet private var coinsButtonsCollectionViewLayout: UICollectionViewFlowLayout?

    private var coins: [CoinType] = []

    private var selectedItemsIndexPaths: [IndexPath] = [] {
        didSet {
            let selectedCoins = coins.enumerated().filter({
                coin in

                selectedItemsIndexPaths.contains { indexPath in
                    indexPath.item == coin.offset
                }
            }).map { $0.element }
            onFilterChanged?(selectedCoins)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325.0, height: 163.0 + insets.top + insets.bottom)
    }

    override func initFromNib() {
        super.initFromNib()

        coinsButtonsCollectionView?.register(CoinItemComponent.self, forCellWithReuseIdentifier: "CoinItemComponent")
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textAlignment = .left

        //coinsButtonsCollectionViewLayout?.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
        coinsButtonsCollectionView?.clipsToBounds = false
        coinsButtonsCollectionView?.backgroundColor = .clear
        coinsButtonsCollectionView?.delegate = self
        coinsButtonsCollectionView?.dataSource = self
    }

    func setTitle(_ title: String) {
        titleLabel?.text = title
    }

    func prepare(coins: [CoinType], selectedIndexes: [Int]) {
        self.coins = coins
        self.selectedItemsIndexPaths = selectedIndexes.map { IndexPath(item: $0, section: 0) }

        coinsButtonsCollectionView?.reloadData()

        invalidateIntrinsicContentSize()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coins.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinItemComponent", for: indexPath)

        guard let cell = _cell as? CoinItemComponent else {
            fatalError()
        }

        let coin = coins[indexPath.item]
        cell.configure(avatar: coin.image, name: coin.short.uppercased())
        cell.onTap = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            if let index = strongSelf.selectedItemsIndexPaths.index(of: indexPath) {
                strongSelf.selectedItemsIndexPaths.remove(at: index)
            } else {
                strongSelf.selectedItemsIndexPaths.forEach {
                    guard let item = collectionView.cellForItem(at: $0) as? CoinItemComponent else {
                        fatalError()
                    }
                    item.unselect()
                }
                strongSelf.selectedItemsIndexPaths.removeAll()

                strongSelf.selectedItemsIndexPaths.append(indexPath)
            }
        }

        if selectedItemsIndexPaths.contains(indexPath) {
            cell.select()
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 88.0, height: 88.0)
    }
}
