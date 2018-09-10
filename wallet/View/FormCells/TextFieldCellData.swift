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
    let action: TextFieldCellDataAction?

    let beginEditingAction: ((UITextField) -> Void)?
}
