//
//  CountryIconImageView.swift
//  wallet
//
//  Created by  me on 30/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CountryView: UIView {

    private var innerImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()

        innerImageView.frame = bounds.insetBy(dx: 4.0, dy: 4.0)

        let minimalSide = min(bounds.width, bounds.height)
        layer.cornerRadius = minimalSide / 2

        let minimalInnerSide = min(innerImageView.bounds.width, innerImageView.bounds.height)
        innerImageView.layer.cornerRadius = minimalInnerSide / 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubviews()
        setupStyle()
    }

    private func addSubviews() {
        innerImageView = UIImageView(frame: CGRect.zero)

        innerImageView.clipsToBounds = true
        innerImageView.frame = bounds
        innerImageView.contentMode = .scaleAspectFill
        innerImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        addSubview(innerImageView)
    }

    private func setupStyle() {
        layer.masksToBounds = true
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.04)
    }

    func setImage(_ image: UIImage) {
        self.innerImageView.image = image
    }
}
