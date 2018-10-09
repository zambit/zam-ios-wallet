//
//  IndentLabel.swift
//  wallet
//
//  Created by  me on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class IndentLabel: UILabel {

    fileprivate var indent: String?
}

extension BehaviorExtension where Base: IndentLabel {

    func setIndent(_ indent: String) {
        guard let text = base.text else {
            return
        }

        if let oldIndent = base.indent,
            let oldIndentRange = text.range(of: oldIndent) {
            base.text?.removeSubrange(oldIndentRange)
        }

        base.text?.addPrefixIfNeeded(indent)
        base.indent = indent
    }

    func setText(_ text: String) {
        if let indent = base.indent {
            base.text = "\(indent)\(text)"
        } else {
            base.text = text
        }
    }

    var text: String? {
        if let indent = base.indent, let text = base.text, text.count >= indent.count {
            return text[indent.count..<text.count]
        }

        return base.text
    }
}
