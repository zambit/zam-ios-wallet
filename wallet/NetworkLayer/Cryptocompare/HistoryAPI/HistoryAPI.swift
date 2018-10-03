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

    func getHistoricalDailyData(for coin: CoinType, days: Int) -> Promise<[CoinDailyPriceData]> {
        return provider.execute(HistoryRequest.getDailyData(coin: coin.rawValue.uppercased(), toCoin: "USD", limit: days))
            .then {
                (response: Response) -> Promise<[CoinDailyPriceData]> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableHistoricalData) -> Void = { s in
                            let objects = s.data.map({ return CoinDailyPriceData(coin: coin, codable: $0) })
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
