//
//  ContactItemComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 28/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class ContactItemComponent: RectItemComponent {

    override var nibName: String {
        return "RectItemComponent"
    }

    override func initFromNib() {
        super.initFromNib()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setupStyle() {
        super.setupStyle()

        view.backgroundColor = .clear

        let unselected: UIView = UIView(frame: bounds)
        let unselectedInside = UIView(frame: bounds)
        unselectedInside.cornerRadius = 16.0
        unselectedInside.backgroundColor = .darkSlateBlue
        unselectedInside.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        unselected.addSubview(unselectedInside)
        backgroundView = unselected

        let selected: UIView = UIView(frame: bounds)
        let selectedInside = UIView(frame: bounds)
        selectedInside.cornerRadius = 16.0
        selectedInside.backgroundColor = .skyBlue
        selectedInside.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selected.addSubview(selectedInside)
        selectedBackgroundView = selected
    }

    @objc
    private func tapGestureEvent(_ sender: UITapGestureRecognizer) {
        onTap?()
    }
}
