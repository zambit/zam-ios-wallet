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
                            do {
                                let wallet = try WalletData(codable: s.data.wallet)
                                seal.fulfill(wallet)
                            } catch let e {
                                seal.reject(e)
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

    func getWallets(token: String, coin: CoinType? = nil, id: String? = nil, page: String? = nil, count: Int? = nil) -> Promise<[WalletData]> {
        return provider.execute(.getUserWallets(token: token, coin: coin?.rawValue, walletId: id, page: page, count: count))
            .then {
                (response: Response) -> Promise<[WalletData]> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessWalletsPageResponse) -> Void = { s in
                            var wallets = s.data.wallets.compactMap {
                                return try? WalletData(codable: $0)
                            }

                            // stub eth and zam

                            let eth = WalletData(id: "t1", name: "Personal", coin: .eth, balance: BalanceData.empty(coin: .eth), address: "afa34f2erq3r122rwd1w1e")

                            let zam = WalletData(id: "t2", name: "Personal", coin: .zam, balance: BalanceData.empty(coin: .zam), address: "afa34f2erq3r122rwd1w1e")

                            wallets.append(eth)
                            wallets.append(zam)

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

    func getWalletInfo(token: String, walletId: String) -> Promise<WalletData> {
        return provider.execute(.getUserWalletInfo(token: token, walletId: walletId))
            .then {
                (response: Response) -> Promise<WalletData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessWalletResponse) -> Void = { s in
                            do {
                                let wallet = try WalletData(codable: s.data.wallet)
                                seal.fulfill(wallet)
                            } catch let e {
                                seal.reject(e)
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

    func getTransactions(token: String, filter: TransactionsFilterData = TransactionsFilterData(), phoneNumberFormatter: PhoneNumberFormatter? = nil, localContacts: [ContactData]? = nil) -> Promise<GroupedTransactionsPageData>  {
        return provider.execute(.getTransactions(token: token, coin: filter.coin?.rawValue, walletId: filter.walletId, recipient: filter.recipient, direction: filter.direction?.rawValue, fromTime: filter.fromTime, untilTime: filter.untilTime, page: filter.page, count: filter.count, group: filter.group.rawValue))
            .then {
                (response: Response) -> Promise<GroupedTransactionsPageData> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessTransactionsGroupedSearchingResponse) -> Void = { s in
                            do {
                                let page = try GroupedTransactionsPageData(codable: s.data)

                                guard let phoneNumberFormatter = phoneNumberFormatter else {
                                    seal.fulfill(page)
                                    return
                                }

                                DispatchQueue.global(qos: .default).async {

                                    let input: [[String]] = page.transactions.map {
                                        group in
                                        group.transactions.map {
                                            $0.participant
                                        }
                                    }

                                    phoneNumberFormatter.getCompleted(from: input) {
                                        parsed in

                                        var newGroups: [TransactionsGroupData] = []

                                        for (i, phones) in parsed.enumerated() {

                                            var newTransactions: [TransactionData] = []

                                            for (j, phone) in phones.enumerated() {
                                                var newTransaction = page.transactions[i].transactions[j]
                                                newTransaction.participantPhoneNumber = phone

                                                if let phone = phone,
                                                    let contacts = localContacts,
                                                    let phoneContact = contacts.first(where: {
                                                        $0.phoneNumbers.contains(phone)
                                                    }) {
                                                    newTransaction.contact = phoneContact
                                                }

                                                newTransactions.append(newTransaction)
                                            }

                                            let newGroup = TransactionsGroupData(dateInterval: page.transactions[i].dateInterval,
                                                                                 amount: page.transactions[i].amount,
                                                                                 transactions: newTransactions)
                                            newGroups.append(newGroup)
                                        }

                                        let newPage = GroupedTransactionsPageData(next: page.next, transactions: newGroups)

                                        DispatchQueue.main.async {
                                            seal.fulfill(newPage)
                                        }
                                    }
                                }
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
