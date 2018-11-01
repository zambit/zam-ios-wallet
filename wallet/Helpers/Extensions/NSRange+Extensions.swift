//
//  NSRange+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 29/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension NSRange {

    func toTextRange(textInput: UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}
