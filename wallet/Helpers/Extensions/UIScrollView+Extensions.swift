//
//  UIScrollView+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIScrollView {

    var minContentOffset: CGPoint {
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top)
    }

    var maxContentOffset: CGPoint {
        return CGPoint(
            x: contentSize.width - bounds.width + contentInset.right,
            y: contentSize.height - bounds.height + contentInset.bottom)
    }
}
