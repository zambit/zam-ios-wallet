//
//  BackSelectingView.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class SelectingBackView: UIView {

    var segmentMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()

    override open var frame: CGRect {
        didSet {
            segmentMaskView.frame = frame
        }
    }

    override open var bounds: CGRect {
        didSet {
            segmentMaskView.bounds = bounds
        }
    }

    override open var center: CGPoint {
        didSet {
            segmentMaskView.center = center
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

}
