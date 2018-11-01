//
//  PriceAPI.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct PriceAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func getCoinDetailPrice(coin: CoinType) -> Promise<CoinPrice> {
        return Promise {
            seal in

            let request = PriceRequest.getDetailPrice(coin: coin.short, toCoin: FiatType.usd.short)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableCoinDataResponse) -> Void = { s in
                        do {
                            guard let codable = s.raw[coin.short]?[FiatType.usd.short] else {
                                let error = CryptocompareResponseError.undefinedServerFailureResponse
                                seal.reject(error)
                                return
                            }

                            let object = try CoinPrice(codable: codable)
                            seal.fulfill(object)
                        } catch let error {
                            seal.reject(error)
                        }
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    func convertCoinAmount(coin: CoinType, amount: Decimal, to fiat: FiatType) -> Promise<Decimal> {
        return Promise {
            seal in

            cancelAllTasks()
            getCoinDetailPrice(coin: coin).done {
                price in

                let fiatAmount = price.price * amount
                seal.fulfill(fiatAmount)
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }


    func cancelAllTasks() {
        provider.cancelAllTasks()
    }
}
