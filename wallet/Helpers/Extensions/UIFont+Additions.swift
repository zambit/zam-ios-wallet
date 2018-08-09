//
//  UIFont+Additions.swift
//  zam.wallet v 0.1
//
//  Generated on Zeplin. (8/9/2018).
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIFont {

    enum WalletWeight: String {
        case regular = "MavenPro-Regular"
        case medium = "MavenPro-Medium"
        case bold = "MavenPro-Bold"
        case black = "MavenPro-Black"
    }

    class func walletFont(ofSize size: CGFloat, weight: WalletWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }

    class var inputTextActive: UIFont {
        return UIFont(name: "MavenPro-Regular", size: 20.0)!
    }

    class var inputTextStatic: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 20.0)!
    }

    class var inputErrorMessage: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 14.0)!
    }

    class var buttonsTextButtonActive: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 16.0)!
    }

    class var inputHelperText: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 14.0)!
    }

    class var titleLargeTitle01: UIFont {
        return UIFont(name: "MavenPro-Bold", size: 34.0)!
    }

    class var discriptionText: UIFont {
        return UIFont(name: "MavenPro-Regular", size: 16.0)!
    }

    class var buttonsTextButtonInactive: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 16.0)!
    }

    class var titleCenteredTitle: UIFont {
        return UIFont(name: "MavenPro-Medium", size: 17.0)!
    }

    class var titleLargeTitle02: UIFont {
        return UIFont(name: "MavenPro-Bold", size: 22.0)!
    }

}
