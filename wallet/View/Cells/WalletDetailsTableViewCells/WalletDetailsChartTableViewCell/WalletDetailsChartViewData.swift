//
//  WalletDetailsChartViewData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct WalletDetailsChartViewData: WalletDetailsViewData, Equatable {

    var type: WalletDetailsCellType {
        return .chart
    }

    let points: [ChartLayer.Coordinate]?
    let currentInterval: CoinPriceChartIntervalType?
}
