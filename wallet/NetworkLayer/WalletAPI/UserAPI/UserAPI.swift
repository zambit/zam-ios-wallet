//
//  UserAPI.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct UserAPI: NetworkService {

    private let provider: UserProvider

    init(provider: UserProvider) {
        self.provider = provider
    }

    func createWallet(token: String, coin: CoinType, walletName: String?) -> Promise<WalletData> {
        return provider.execute(.createWallet(token: token, coin: coin.rawValue, walletName: walletName))
            .then {
                (response: Response) -> Promise<WalletData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessWalletData) -> Void = { s in
                            guard let coinType = CoinType(rawValue: s.data.coin) else {
                                fatalError()
                            }
                            let wallet = WalletData(name: s.data.name, coin: coinType)
                            seal.fulfill(wallet)
                        }

                        let failure: (CodableFailure) -> Void = { f in
                            guard f.errors.count > 0 else {
                                let error = WalletResponseError.undefinedServerFailureResponse
                                seal.reject(error)
                                return
                            }

                            let error = WalletResponseError.serverFailureResponse(errors: f.errors)
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
