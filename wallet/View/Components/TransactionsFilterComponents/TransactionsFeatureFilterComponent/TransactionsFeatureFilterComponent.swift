//
//  TransactionsFeatureFilterComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class TransactionsFeatureFilterComponent: CellComponent, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeatureItemComponentDelegate {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var featuresButtonsCollectionView: UICollectionView?
    @IBOutlet private var featuresButtonsCollectionViewLayout: UICollectionViewFlowLayout?

    private var features: [String] = []

    private weak var selectedFeatureButton: FeatureItemComponent?

    private var isMultipleSelecting: Bool = false

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 325.0, height: 105.0 + insets.top + insets.bottom)
    }

    override func initFromNib() {
        super.initFromNib()

        featuresButtonsCollectionView?.register(FeatureItemComponent.self, forCellWithReuseIdentifier: "FeatureItemComponent")
    }

    override func setupStyle() {
        super.setupStyle()

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

    func prepare(features: [String], isMultipleSelecting: Bool) {
        self.features = features
        self.isMultipleSelecting = isMultipleSelecting
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
        cell.delegate = self
        return cell
    }

    // MARK: - FeatureItemComponentDelegate

    func featureItemComponentWasSelected(_ featureItemComponent: FeatureItemComponent) {
        if !isMultipleSelecting {
            self.selectedFeatureButton?.unselect()
            self.selectedFeatureButton = featureItemComponent
        }
    }

    func featureItemComponentWasUnselected(_ featureItemComponent: FeatureItemComponent) {
        if !isMultipleSelecting {
            self.selectedFeatureButton = nil
        }
    }
}
