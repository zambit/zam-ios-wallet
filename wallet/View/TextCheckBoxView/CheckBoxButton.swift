//
//  CheckBoxButton.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol CheckBox: class {

    var onImage: UIImage { get }
    var offImage: UIImage { get }

    var isChecked: Bool { get set }
}

class CheckBoxButton: UIButton, CustomUI {

    struct CustomAppearance {
        weak var parent: CheckBoxButton?

        var isChecked: Bool {
            return parent?.isSelected ?? false
        }

        func setChecked(_ checked: Bool) {
            parent?.isSelected = checked
        }
    }

    var customAppearance: CheckBoxButton.CustomAppearance {
        return CustomAppearance(parent: self)
    }

    var onImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDone")
    }

    var offImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDo")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    private func setupStyle() {
        self.setImage(onImage, for: .selected)
        self.setImage(offImage, for: .normal)
        
        self.backgroundColor = .clear
    }
}
