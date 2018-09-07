//
//  CircleImageView.swift
//  wallet
//
//  Created by  me on 14/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CircleImageView: UIView {

    private(set) var imageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        addSubview(imageView!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        imageView = UIImageView()
        addSubview(imageView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2

        if let imageView = imageView {
            imageView.frame = bounds.insetBy(dx: 8, dy: 8)
            imageView.layer.cornerRadius = imageView.bounds.width / 2
        }
    }
}
