//
//  TransactionsFilterData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 29/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

struct TransactionsFilterData: Equatable {

    var coin: CoinType?
    var walletId: String?
    var recipient: String?
    var direction: DirectionType?
    var fromTime: String?
    var untilTime: String?
    var page: String?
    var count: Int?
    var group: GroupingType

    init(group: GroupingType = .day, coin: CoinType? = nil, walletId: String? = nil, recipient: String? = nil, direction: DirectionType? = nil, fromTime: String? = nil, untilTime: String? = nil, page: String? = nil, count: Int? = nil) {
        self.group = group
        self.coin = coin
        self.walletId = walletId
        self.recipient = recipient
        self.fromTime = fromTime
        self.untilTime = untilTime
        self.page = page
        self.count = count
    }
}
