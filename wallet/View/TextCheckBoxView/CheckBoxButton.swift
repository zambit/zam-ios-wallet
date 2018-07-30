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

class CheckBoxButton: UIButton, CheckBox {

    var onImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDone")
    }

    var offImage: UIImage {
        return #imageLiteral(resourceName: "icCheckboxDo")
    }

    var isChecked: Bool {
        get {
            return self.isSelected
        }
        set {
            self.isSelected = newValue
        }
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
