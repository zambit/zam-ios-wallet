//
//  CGPoint+Extensions.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension CGPoint {

    var inverted: CGPoint {
        return CGPoint(x: -x, y: -y)
    }
}
