//
//  MigratingWalletTabBarItem.swift
//  wallet
//
//  Created by Alexander Ponomarev on 05/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import ESTabBarController_swift

struct WalletTabBarItemData {

    enum ContentType {
        case large
        case normal

        var view: ESTabBarItemContentView {
            switch self {
            case .large:
                return LargeContentView()
            case .normal:
                return NormalContentView()
            }
        }
    }

    var image: UIImage
    var type: ContentType
    var title: String?
}

class LargeContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        iconColor = .white
        highlightIconColor = .white
        highlightEnabled = false

        itemContentMode = .alwaysOriginal
        renderingMode = .alwaysOriginal
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NormalContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.white.withAlphaComponent(0.5)
        highlightTextColor = .white
        iconColor = UIColor.white.withAlphaComponent(0.5)
        highlightIconColor = .skyBlue

        itemContentMode = .alwaysTemplate
        renderingMode = .alwaysTemplate
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
