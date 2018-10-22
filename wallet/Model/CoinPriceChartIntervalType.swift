//
//  CoinPriceChartIntervalType.swift
//  wallet
//
//  Created by Alexander Ponomarev on 18/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

enum CoinPriceChartIntervalType: Int, CaseIterable {
    case day = 0
    case week
    case month
    case threeMonth
    case year
    case all

    var title: String {
        switch self {
        case .day:
            return "1 d"
        case .week:
            return "7 d"
        case .month:
            return "1 m"
        case .threeMonth:
            return "3 m"
        case .year:
            return "1 y"
        case .all:
            return "All"
        }
    }
}
