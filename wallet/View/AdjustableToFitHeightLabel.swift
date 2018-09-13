//
//  AdjustableToFitHeightLabel.swift
//  wallet
//
//  Created by Alexander Ponomarev on 13/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class AdjustableToFitHeightLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }

    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {

        var minFontSize: CGFloat = 0 // CGFloat 18
        var maxFontSize: CGFloat = 18     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0

        guard let text = text else {
            let fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            return font.withSize(fontSizeAverage)
        }

        while (minFontSize <= maxFontSize) {

            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2

            // Abort if text happens to be nil
            guard text.count > 0 else {
                break
            }

            let labelText = text as NSString
            let labelHeight = frame.size.height

            let testStringHeight = labelText.size(withAttributes: [.font : font.withSize(fontSizeAverage)]).height

            textAndLabelHeightDiff = labelHeight - testStringHeight

            if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                if (textAndLabelHeightDiff < 0) {
                    return font.withSize(fontSizeAverage - 1)
                }
                return font.withSize(fontSizeAverage)
            }

            if (textAndLabelHeightDiff < 0) {
                maxFontSize = fontSizeAverage - 1

            } else if (textAndLabelHeightDiff > 0) {
                minFontSize = fontSizeAverage + 1

            } else {
                return font.withSize(fontSizeAverage)
            }
        }
        return font.withSize(fontSizeAverage)
    }
}
