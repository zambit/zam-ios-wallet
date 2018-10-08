//
//  CardsCollectionComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 08/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol WalletsCollectionComponentDelegate: class {

    func walletsCollectionComponentCurrentIndexChanged(_ walletsCollectionComponent: WalletsCollectionComponent, to index: Int)
}

class WalletsCollectionComponent: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    typealias Item = WalletSmallItemComponent

    weak var delegate: WalletsCollectionComponentDelegate?

    fileprivate var collectionView: UICollectionView!
    fileprivate var data: [Item.ConfiguratingType] = []
    fileprivate(set) var currentIndex: Int = 0

    var currentItem: Item? {
        return collectionView.visibleCells.first as? Item
    }

    var currentItemData: Item.ConfiguratingType? {
        guard currentIndex < data.count else {
            return nil
        }
        return data[currentIndex]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setup()
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: Item().nibName, for: indexPath)

        guard let cell = _cell as? WalletSmallItemComponent else {
            fatalError()
        }

        guard indexPath.section < data.count else {
            return UICollectionViewCell()
        }

        if indexPath.section == currentIndex {
            cell.setTargetToAnimation()
        }

        let itemData = data[indexPath.section]
        cell.configure(with: itemData)
        cell.setupPages(currentIndex: indexPath.section, count: data.count)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint), data.count > indexPath.section else {
            return
        }

        self.currentIndex = indexPath.section
        delegate?.walletsCollectionComponentCurrentIndexChanged(self, to: currentIndex)
    }
}

extension BehaviorExtension where Base: WalletsCollectionComponent {

    func prepare(cards: [Base.Item.ConfiguratingType], current: Int = 0) {
        base.data = cards
        base.currentIndex = current

        base.collectionView.reloadData()
        base.collectionView.layoutIfNeeded()

        let indexPath = IndexPath(item: 0, section: current)
        base.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    func prepareForAnimation() {
        base.collectionView.visibleCells.compactMap {
            return $0 as? WalletSmallItemComponent
        }.forEach {
            $0.removeTargetToAnimation()
        }

        let indexPath = IndexPath(item: 0, section: base.currentIndex)
        (base.collectionView.cellForItem(at: indexPath) as? WalletSmallItemComponent)?.setTargetToAnimation()
    }

    fileprivate func setup() {
        setupStyle()
        setupSubviews()
    }

    fileprivate func setupSubviews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(Base.Item.self , forCellWithReuseIdentifier: Base.Item().nibName)
        collectionView.dataSource = base
        collectionView.delegate = base
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false

        base.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: base.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: base.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.collectionView = collectionView

        base.layoutIfNeeded()
    }

    fileprivate func setupStyle() {
        base.backgroundColor = .clear
    }
}
