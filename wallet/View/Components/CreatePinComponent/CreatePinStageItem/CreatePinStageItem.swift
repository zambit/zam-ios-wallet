//
//  CreatePinStageItem.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CreatePinStageItem: ItemComponent {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var dotsFieldComponent: DotsFieldComponent?

    func configure(data: CreatePinStageData) {
        titleLabel?.text = data.title
        dotsFieldComponent?.dotsMaxCount = data.codeLength
    }

    override func initFromNib() {
        super.initFromNib()
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.textColor = .white
    }
}
