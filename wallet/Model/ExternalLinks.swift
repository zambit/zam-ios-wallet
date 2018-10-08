//
//  SocialLink.swift
//  wallet
//
//  Created by Alexander Ponomarev on 14/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum ExternalLinks {

    case telegram
    case twitter
    case medium
    case facebook
    case message
    case terms
    case privacy

    var url: URL {
        switch self {
        case .telegram:
            return URL(string: "https://t.me/zamzamchat")!
        case .twitter:
            return URL(string: "https://twitter.com/zamzambank")!
        case .medium:
            return URL(string: "https://medium.com/@zamzamofficial")!
        case .facebook:
            return URL(string: "https://www.facebook.com/zamzambank")!
        case .terms:
            return URL(string: "https://terms.zam.io/TERMS_OF_USE_for_site.pdf")!
        case .privacy:
            return URL(string: "https://privacy.zam.io/PRIVACY_POLICY.pdf")!
        case .message:
            let email = "support@zam.me"
            return URL(string: "mailto:\(email)")!
        }
    }
}
