//
//  CreatePinComponent.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreatePinComponent: Component, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView?

    var currentPinStage: CreatePinStageItem? {
        guard let item = collectionView?.cellForItem(at: currentItemIndexPath) else {
            return nil
        }

        return (item as! CreatePinStageItem)
    }

    private var createPinStages: [CreatePinStageData] = []

    private var currentItemIndexPath = IndexPath(item: 0, section: 0)

    override func initFromNib() {
        super.initFromNib()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            //...
            break
        case .extra, .medium:
            //...
            break
        case .plus:
            //....
            break
        case .unknown:
            break
        }

        createPinStages = [
            CreatePinStageData(title: "Create PIN-code", codeLength: 4),
            CreatePinStageData(title: "Confirm PIN-code", codeLength: 4)
        ]

        collectionView?.register(CreatePinStageItem.self, forCellWithReuseIdentifier: "CreatePinStageItem")

        collectionView?.delegate = self
        collectionView?.dataSource = self

        self.clipsToBounds = false
        self.collectionView?.clipsToBounds = false
    }

    override func setupStyle() {
        super.setupStyle()

        collectionView?.backgroundColor = .clear
    }

    func scrollToNext(animated: Bool) {
        currentItemIndexPath.section += 1

        collectionView?.scrollToItem(at: currentItemIndexPath, at: .centeredHorizontally, animated: animated)
    }

    // UICollectionView dataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return createPinStages.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePinStageItem", for: indexPath)

        guard let cell = _cell as? CreatePinStageItem else {
            fatalError()
        }

        cell.configure(data: createPinStages[indexPath.section])
        return cell
    }

    // UICollectionView delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

struct CreatePinStageData {
    var title: String
    var codeLength: Int
}
