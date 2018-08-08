//
//  CustomOverlappingFlowLayout.swift
//  wallet
//
//  Created by  me on 08/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CustomOverlappingFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        for currentLayoutAttributes: UICollectionViewLayoutAttributes in layoutAttributes! {

            // zIndex - Specifies the item’s position on the z-axis.
            // Unlike a layer's zPosition, changing zIndex allows us to change not only layer position,
            // but tapping/UI interaction logic too as it moves the whole item.
            currentLayoutAttributes.zIndex = currentLayoutAttributes.indexPath.item + 1
        }

        return layoutAttributes
    }
}
