//
//  TextFieldCellData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 10/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

enum TextFieldCellDataAction {
    case tap((UITextField) -> Void)
    case editingChanged((UITextField) -> Void)
}

struct TextFieldCellData {

    let placeholder: String
    let keyboardType: UIKeyboardType?
    let autocapitalizationType: UITextAutocapitalizationType?
    let autocorrectionType: UITextAutocorrectionType?

    let action: TextFieldCellDataAction?
    let beginEditingAction: ((TextFieldCell) -> Void)?
}