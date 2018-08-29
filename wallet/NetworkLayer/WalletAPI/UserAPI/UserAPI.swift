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

    func getUserInfo(token: String, coin: CoinType?) -> Promise<UserData> {
        return provider.execute(.userInfo(token: token, coin: coin?.rawValue))
            .then {
                (response: Response) -> Promise<UserData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessUserInfoResponse) -> Void = { s in
                            do {
                                let user = try UserData(codable: s.data)
                                seal.fulfill(user)
                            } catch let error {
                                seal.reject(error)
                            }
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

    func createWallet(token: String, coin: CoinType, walletName: String?) -> Promise<WalletData> {
        return provider.execute(.createWallet(token: token, coin: coin.rawValue, walletName: walletName))
            .then {
                (response: Response) -> Promise<WalletData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessWalletResponse) -> Void = { s in
                            let wallet = try! WalletData(codable: s.data)
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

    func getWallets(token: String, coin: CoinType? = nil, id: String? = nil, page: String? = nil, count: Int? = nil) -> Promise<[WalletData]> {
        return provider.execute(.getUserWallets(token: token, coin: coin?.rawValue, walletId: id, page: page, count: count))
            .then {
                (response: Response) -> Promise<[WalletData]> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessWalletsPageResponse) -> Void = { s in
                            let wallets = s.data.wallets.compactMap {
                                return try? WalletData(codable: $0)
                            }

                            seal.fulfill(wallets)
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

    func sendTransaction(token: String, walletId: String, recipient: String, amount: Decimal) -> Promise<TransactionData>  {
        return provider.execute(.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount))
            .then {
                (response: Response) -> Promise<TransactionData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessTransactionResponse) -> Void = { s in
                            do {
                                let transaction = try TransactionData(codable: s.data.transaction)
                                seal.fulfill(transaction)
                            } catch let error {
                                seal.reject(error)
                            }
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

    func getTransactions(token: String, filter: TransactionsFilterData = TransactionsFilterData()) -> Promise<GroupedTransactionsPageData>  {
        return provider.execute(.getTransactions(token: token, coin: filter.coin?.rawValue, walletId: filter.walletId, recipient: filter.recipient, direction: filter.direction?.rawValue, fromTime: filter.fromTime, untilTime: filter.untilTime, page: filter.page, count: filter.count, group: filter.group.rawValue))
            .then {
                (response: Response) -> Promise<GroupedTransactionsPageData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessTransactionsGroupedSearchingResponse) -> Void = { s in
                            do {
                                let page = try GroupedTransactionsPageData(codable: s.data)
                                seal.fulfill(page)
                            } catch let error {
                                seal.reject(error)
                            }
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

    func cancelTasks() {
        provider.cancelAllTasks()
    }
}
