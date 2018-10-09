//
//  CheckBoxButton.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        custom.setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom.setupStyle()
    }
}

extension BehaviorExtension where Base: CheckBoxButton {

    var onImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDone")
    }

    var offImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDo")
    }

    var isChecked: Bool {
        return base.isSelected
    }

    func setChecked(_ checked: Bool) {
        base.isSelected = checked
    }

    fileprivate func setupStyle() {
        base.setImage(onImage, for: .selected)
        base.setImage(offImage, for: .normal)

        base.backgroundColor = .clear
    }
}
