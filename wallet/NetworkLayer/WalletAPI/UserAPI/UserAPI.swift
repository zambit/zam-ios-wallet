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

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func getUserInfo(token: String, coin: CoinType?) -> Promise<UserData> {
        return provider.execute(UserRequest.userInfo(token: token, coin: coin?.rawValue))
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
        return provider.execute(UserRequest.createWallet(token: token, coin: coin.rawValue, walletName: walletName))
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
        return provider.execute(UserRequest.getUserWallets(token: token, coin: coin?.rawValue, walletId: id, page: page, count: count))
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

    func getWalletInfo(token: String, walletId: String) -> Promise<WalletData> {
        return provider.execute(UserRequest.getUserWalletInfo(token: token, walletId: walletId))
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
        return provider.execute(UserRequest.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount))
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

        // Get timezone
        let timezoneOffset = Float(TimeZone.current.secondsFromGMT()) / 3600.0
        let timezoneOffsetString = NumberFormatter.output.string(from: NSNumber(value: timezoneOffset))

        return provider.execute(UserRequest.getTransactions(token: token, coin: filter.coin?.rawValue, walletId: filter.walletId, recipient: filter.recipient, direction: filter.direction?.rawValue, fromTime: filter.fromTime, untilTime: filter.untilTime, timezone: timezoneOffsetString, page: filter.page, count: filter.count, group: filter.group.rawValue))
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
                                                        $0.phoneNumbers.contains(phone.numberString)
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

    func getKYCPersonalInfo(token: String) -> Promise<KYCPersonalInfo> {
        return provider.execute(UserRequest.getKYCPersonalInfo(token: token))
            .then {
                (response: Response) -> Promise<KYCPersonalInfo> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessKYCPersonalInfoResponse) -> Void = { s in
                            do {
                                let info = try KYCPersonalInfo(codable: s.data)
                                seal.fulfill(info)
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

    func sendKYCPersonalInfo(token: String, personalData: KYCPersonalInfoData) -> Promise<Void> {
        return self.sendKYCPersonalInfo(token: token, email: personalData.email, firstName: personalData.firstName, lastName: personalData.lastName, birthDate: personalData.birthDate, gender: personalData.gender, country: personalData.country, city: personalData.city, region: personalData.region, street: personalData.street, house: personalData.house, postalCode: personalData.postalCode)
    }

    func sendKYCPersonalInfo(token: String, email: String, firstName: String, lastName: String, birthDate: Date, gender: GenderType, country: String, city: String, region: String, street: String, house: String, postalCode: Int) -> Promise<Void> {
        return provider.execute(UserRequest.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: String(Int(birthDate.unixTimestamp)), sex: gender.rawValue, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode))
            .then {
                (response: Response) -> Promise<Void> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessEmptyResponse) -> Void = { s in
                            seal.fulfill(())
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
