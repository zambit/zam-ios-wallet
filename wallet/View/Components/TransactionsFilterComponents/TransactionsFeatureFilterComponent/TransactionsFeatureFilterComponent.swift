//
//  TransactionsFeatureFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsFeatureFilterComponent: CellComponent, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var onFeatureFilterChanged: (([String]) -> Void)?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var featuresButtonsCollectionView: UICollectionView?
    @IBOutlet private var featuresButtonsCollectionViewLayout: UICollectionViewFlowLayout?

    private var features: [String] = []

    private var selectedItemsIndexPaths: [IndexPath] = [] {
        didSet {
            let selectedFeatures = features.enumerated().filter({
                feature in

                selectedItemsIndexPaths.contains { indexPath in
                    indexPath.item == feature.offset
                }
            }).map { $0.element }
            selectedFeaturesWasUpdated(selectedFeatures)
        }
    }

    private weak var selectedFeatureButton: FeatureItemComponent?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325.0, height: 105.0 + insets.top + insets.bottom)
    }

    override func initFromNib() {
        super.initFromNib()

        featuresButtonsCollectionView?.register(FeatureItemComponent.self, forCellWithReuseIdentifier: "FeatureItemComponent")
    }

    override func setupStyle() {
        super.setupStyle()

        featuresButtonsCollectionView?.clipsToBounds = false

        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textAlignment = .left

        featuresButtonsCollectionViewLayout?.estimatedItemSize = CGSize(width: 1.0, height: 1.0)
        featuresButtonsCollectionView?.backgroundColor = .clear
        featuresButtonsCollectionView?.delegate = self
        featuresButtonsCollectionView?.dataSource = self
    }

    func setTitle(_ title: String) {
        titleLabel?.text = title
    }

    func prepare(features: [String], selectedIndexes: [Int]) {
        self.features = features
        self.selectedItemsIndexPaths = selectedIndexes.map { IndexPath(item: $0, section: 0) }

        featuresButtonsCollectionView?.reloadData()

        invalidateIntrinsicContentSize()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureItemComponent", for: indexPath)

        guard let cell = _cell as? FeatureItemComponent else {
            fatalError()
        }

        let feature = features[indexPath.item]
        cell.configure(title: feature)
        cell.onTap = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            if let index = strongSelf.selectedItemsIndexPaths.index(of: indexPath) {
                strongSelf.selectedItemsIndexPaths.remove(at: index)
            } else {
                strongSelf.selectedItemsIndexPaths.forEach {
                    guard let item = collectionView.cellForItem(at: $0) as? FeatureItemComponent else {
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

    func selectedFeaturesWasUpdated(_ features: [String]) {
        onFeatureFilterChanged?(features)
    }
}
