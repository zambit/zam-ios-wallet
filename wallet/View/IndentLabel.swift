//
//  IndentLabel.swift
//  wallet
//
//  Created by  me on 16/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class IndentLabel: UILabel, CustomUI {

    struct CustomAppearance {
        weak var parent: IndentLabel?

        func setIndent(_ indent: String) {
            guard
                let parent = parent,
                let text = parent.text else {
                return
            }

            if let oldIndent = parent.indent,
                let oldIndentRange = text.range(of: oldIndent) {
                parent.text?.removeSubrange(oldIndentRange)
            }

            parent.text?.addPrefixIfNeeded(indent)
            parent.indent = indent
        }

        func setText(_ text: String) {
            if let indent = parent?.indent {
                parent?.text = "\(indent)\(text)"
            } else {
                parent?.text = text
            }
        }

        var text: String? {
            if let indent = parent?.indent, let text = parent?.text, text.count >= indent.count {
                return text[indent.count..<text.count]
            }

            return parent?.text
        }
    }

    var customAppearance: CustomAppearance {
        return CustomAppearance(parent: self)
    }


    private var indent: String?

}
