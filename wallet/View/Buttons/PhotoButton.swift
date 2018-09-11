//
//  PhotoButton.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class PhotoButton: UIButton {

    var placeholderImageView: UIImageView?
    var previewImageView: UIImageView?

    override func layoutSubviews() {
        super.layoutSubviews()
        custom.setupLayouts()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(nil, for: UIControlState())
        custom.setupStyle()
        custom.setupEmpty()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle(nil, for: UIControlState())
        custom.setupStyle()
        custom.setupEmpty()
    }
}

extension BehaviorExtension where Base: PhotoButton {

    func setup(photo: UIImage) {
        base.viewWithTag(193114)?.removeFromSuperview()
        base.viewWithTag(1681612)?.removeFromSuperview()

        let previewImageView = UIImageView()
        previewImageView.image = photo
        previewImageView.tag = 193114

        base.addSubview(previewImageView)

        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
        previewImageView.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        previewImageView.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true

        base.previewImageView = previewImageView

        base.layer.borderWidth = 0.0
    }

    func setupEmpty() {
        base.viewWithTag(193114)?.removeFromSuperview()
        base.viewWithTag(1681612)?.removeFromSuperview()

        let placeholderImageView = UIImageView()
        placeholderImageView.image = #imageLiteral(resourceName: "icAddPhoto")
        placeholderImageView.tintColor = UIColor.black.withAlphaComponent(0.6)
        placeholderImageView.tag = 1681612

        base.addSubview(placeholderImageView)

        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.centerXAnchor.constraint(equalTo: base.centerXAnchor, constant: 2.0).isActive = true
        placeholderImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
        placeholderImageView.heightAnchor.constraint(equalTo: placeholderImageView.widthAnchor).isActive = true
        placeholderImageView.heightAnchor.constraint(equalToConstant: 34.0).isActive = true

        base.placeholderImageView = placeholderImageView

        base.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        base.layer.borderWidth = 1.0
    }

    func setupStyle() {
        base.maskToBounds = true
        base.backgroundColor = .white
    }

    func setupLayouts() {
        base.layer.cornerRadius = 12
    }
}
