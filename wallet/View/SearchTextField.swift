//
//  SearchTextField.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class SearchTextField: UITextField {

    private var rightDetailImageView: UIImageView?

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    private func addSubviews() {
        rightDetailImageView?.removeFromSuperview()

        leftPadding = 24.0
        rightPadding = 32.0

        rightDetailImageView = UIImageView()
        rightDetailImageView?.backgroundColor = .clear
        rightDetailImageView?.translatesAutoresizingMaskIntoConstraints = false
        rightDetailImageView?.image = #imageLiteral(resourceName: "icSearchBlue")
        rightDetailImageView?.tintColor = UIColor.cornflower.withAlphaComponent(0.4)

        insertSubview(rightDetailImageView!, at: 0)

        rightDetailImageView?.heightAnchor.constraint(equalTo: rightDetailImageView!.widthAnchor).isActive = true
        rightDetailImageView?.heightAnchor.constraint(equalToConstant: 16.0).isActive = true

        rightDetailImageView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightDetailImageView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -12.0).isActive = true

        layoutIfNeeded()
    }
}
