//
//  HistoryAPI.swift
//  wallet
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct HistoryAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Get historical price per day.

     - parameter coin: Coin, requesting price for.
     - parameter convertingTo: Fiat coin, receiving price values converting to.
     - parameter groupingBy: Time period to aggregate receiving price data. Default value is one - unit of receiving price data equals day price data.
     - parameter count: Count of groups receiving.

     - returns: Array of price data structures.
     */
    func getHistoricalDailyPrice(for coin: CoinType, convertingTo: FiatType = .standard, groupingBy: Int = 1, count: Int) -> Promise<[CoinHistoricalPrice]> {
        return getHistoricalPrice(for: coin, convertingTo: convertingTo, interval: .day, groupingBy: groupingBy, count: count)
    }

    /**
     Get historical price per hour.

     - parameter coin: Coin, requesting price for.
     - parameter convertingTo: Fiat coin, receiving price values converting to.
     - parameter groupingBy: Time period to aggregate receiving price data. Default value is one - unit of receiving price data equals hour price data.
     - parameter count: Count of groups receiving.

     - returns: Array of price data structures.
     */
    func getHistoricalHourlyPrice(for coin: CoinType, convertingTo: FiatType = .standard, groupingBy: Int = 1, count: Int) -> Promise<[CoinHistoricalPrice]> {
        return getHistoricalPrice(for: coin, convertingTo: convertingTo, interval: .hour, groupingBy: groupingBy, count: count)
    }

    /**
     Get historical price per minute.

     - parameter coin: Coin, requesting price for.
     - parameter convertingTo: Fiat coin, receiving price values converting to.
     - parameter groupingBy: Time period to aggregate receiving price data. Default value is one - unit of receiving price data equals minute price data.
     - parameter count: Count of groups receiving.

     - returns: Array of price data structures.
     */
    func getHistoricalMinutePrice(for coin: CoinType, convertingTo: FiatType = .standard, groupingBy: Int = 1, count: Int) -> Promise<[CoinHistoricalPrice]> {
        return getHistoricalPrice(for: coin, convertingTo: convertingTo, interval: .minute, groupingBy: groupingBy, count: count)
    }

    enum HistoricalInterval {
        case day
        case hour
        case minute
    }

    func getHistoricalPrice(for coin: CoinType, convertingTo: FiatType, interval: HistoricalInterval, groupingBy: Int, count: Int) -> Promise<[CoinHistoricalPrice]> {

        var request: HistoryRequest
        switch interval {
        case .day:
            request = .getDailyPrice(coin: coin.short, toCoin: convertingTo.short, aggregate: groupingBy, limit: count)
        case .hour:
            request = .getHourlyPrice(coin: coin.short, toCoin: convertingTo.short, aggregate: groupingBy, limit: count)
        case .minute:
            request = .getMinutePrice(coin: coin.short, toCoin: convertingTo.short, aggregate: groupingBy, limit: count)
        }

        return provider.execute(request)
            .then {
                (response: Response) -> Promise<[CoinHistoricalPrice]> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableCoinHistoricalDataResponse) -> Void = { s in
                            let objects = s.data.map({ return CoinHistoricalPrice(coin: coin, codable: $0) })
                            seal.fulfill(objects)
                        }

                        let failure: (CodableCryptocompareFailure) -> Void = { f in
                            let error = CryptocompareResponseError.serverFailureResponse(message: f.message)
                            seal.reject(error)
                        }

                        do {
                            try response.extractResult(success: success, failure: failure)
                        } catch let error {
                            seal.reject(error)
                        }
                    case .error(let error):
                        seal.reject(error)
                    }
                }
        }
    }
}
