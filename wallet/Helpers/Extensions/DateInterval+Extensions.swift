//
//  DateInterval+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension DateInterval {

    init(startUnixTimestamp: Double, endUnixTimestamp: Double) {
        let start = Date(unixTimestamp: startUnixTimestamp)
        let end = Date(unixTimestamp: endUnixTimestamp)

        self.init(start: start, end: end)
    }

    static func walletString(from interval: DateInterval) -> String {
        let time = Int(interval.duration)

        switch time/3600 > 24 {
        case true:
            return "\(interval.start.shortFormatted) - \(interval.end.shortFormatted)"
        case false:
            return interval.start.shortFormatted
        }
    }

}
