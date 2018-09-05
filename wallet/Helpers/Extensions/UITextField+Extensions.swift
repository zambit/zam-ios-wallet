//
//  UITextField+Extensions.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    var leftPadding: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.size.height))
            leftView = paddingView
            leftView?.frame.size.width = newValue
            leftViewMode = .always
            leftView?.isUserInteractionEnabled = false
        }
    }

    var rightPadding: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.size.height))
            rightView = paddingView
            rightView?.frame.size.width = newValue
            rightViewMode = .always
            rightView?.isUserInteractionEnabled = false
        }
    }
}


extension UITextField {

    func resizeFontToFitWidth(minimalSize: CGFloat, maximumSize: CGFloat) {
        guard let text = self.text, let _font = self.font else {
            return
        }

        var font = _font

        let textString = text as NSString
        var widthOfText = textString.size(withAttributes: [.font : font]).width
        var widthOfFrame = self.frame.size.width

        // increase font size until it fits or reach maximumSize
        while widthOfFrame - 5 >= widthOfText, font.pointSize <= maximumSize {
            let fontSize = font.pointSize
            font = font.withSize(fontSize + 0.5)
            widthOfText = textString.size(withAttributes: [.font : font]).width
            widthOfFrame = self.frame.size.width
        }

        // decrease font size until it fits or reach minimumSize
        while widthOfFrame - 5 < widthOfText, font.pointSize >= minimalSize {
            let fontSize = font.pointSize
            font = font.withSize(fontSize - 0.5)
            widthOfText = textString.size(withAttributes: [.font : font]).width
            widthOfFrame = self.frame.size.width
        }

        self.font = font
    }
}
