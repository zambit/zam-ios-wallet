//
//  UserAPI.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 * User's data flow API. Provides request for getting general user's info, wallets and transactions and sending crypto.
 */
struct UserAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Get general user info: id, phone, kyc status and balance.

     - parameter token: Current session's token.
     - parameter coin: -

     - returns: User's id, phone number, general balance, kyc status, registration time.
     */
    func getUserInfo(token: String, coin: CoinType?) -> Promise<User> {
        return provider.execute(UserRequest.userInfo(token: token, coin: coin?.rawValue))
            .then {
                (response: Response) -> Promise<User> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableUserInfoResponse) -> Void = { s in
                            do {
                                let user = try User(codable: s.data)
                                seal.fulfill(user)
                            } catch let error {
                                seal.reject(error)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    func createWallet(token: String, coin: CoinType, walletName: String?) -> Promise<Wallet> {
        return provider.execute(UserRequest.createWallet(token: token, coin: coin.rawValue, walletName: walletName))
            .then {
                (response: Response) -> Promise<Wallet> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableWalletResponse) -> Void = { s in
                            do {
                                let wallet = try Wallet(codable: s.data.wallet)
                                seal.fulfill(wallet)
                            } catch let e {
                                seal.reject(e)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Get users wallets list.

     - parameter token: Current session's token.
     - parameter coin: Filter receiving wallets list by coin.
     - parameter id: Filter receiving wallets list by wallet id.
     - parameter page: Link on specific page of list.
     - parameter count: Count of wallets per page.

     - returns: Array of wallets data structures.
     */
    func getWallets(token: String, coin: CoinType? = nil, id: String? = nil, page: String? = nil, count: Int? = nil) -> Promise<[Wallet]> {
        return provider.execute(UserRequest.getUserWallets(token: token, coin: coin?.rawValue, walletId: id, page: page, count: count))
            .then {
                (response: Response) -> Promise<[Wallet]> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableWalletsPageResponse) -> Void = { s in
                            let wallets = s.data.wallets.compactMap {
                                return try? Wallet(codable: $0)
                            }

                            seal.fulfill(wallets)
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Get wallet's info by id.

     - parameter token: Current session's token.
     - parameter walletId: Wallet's id.

     - returns: Wallet's data.
     */
    func getWalletInfo(token: String, walletId: String) -> Promise<Wallet> {
        return provider.execute(UserRequest.getUserWalletInfo(token: token, walletId: walletId))
            .then {
                (response: Response) -> Promise<Wallet> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableWalletResponse) -> Void = { s in
                            do {
                                let wallet = try Wallet(codable: s.data.wallet)
                                seal.fulfill(wallet)
                            } catch let e {
                                seal.reject(e)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Send money from specific wallet.

     - parameter token: Current session's token.
     - parameter walletId: Source wallet's id.
     - parameter recipient: Recipient's phone or wallet address.
     - parameter amount: Amount of crypto.

     - returns: Information about sended transaction.
     */
    func sendTransaction(token: String, walletId: String, recipient: String, amount: Decimal) -> Promise<Transaction>  {
        return provider.execute(UserRequest.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount))
            .then {
                (response: Response) -> Promise<Transaction> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableTransactionResponse) -> Void = { s in
                            do {
                                let transaction = try Transaction(codable: s.data.transaction)
                                seal.fulfill(transaction)
                            } catch let error {
                                seal.reject(error)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Get list of user's incoming and outgoing transactions.

     - parameter token: Current session's token.
     - parameter filter: List filter properties.
     - parameter phoneNumberFormatter: Phone numbers formatter for converting transactions recipients phones to inner system format.
     - parameter localContacts: List of users contacts for replacing transactions phone numbers with appropriated contacts names.

     - returns: Page of grouped by time interval transactions.
     */
    func getTransactions(token: String, filter: TransactionsFilterProperties = TransactionsFilterProperties(), phoneNumberFormatter: PhoneNumberFormatter? = nil, localContacts: [Contact]? = nil) -> Promise<TransactionsPage>  {

        // Get timezone
        let timezoneOffset = Float(TimeZone.current.secondsFromGMT()) / 3600.0
        let timezoneOffsetString = NumberFormatter.output.string(from: NSNumber(value: timezoneOffset))

        return provider.execute(UserRequest.getTransactions(token: token, coin: filter.coin?.rawValue, walletId: filter.walletId, recipient: filter.recipient, direction: filter.direction?.rawValue, fromTime: filter.fromTime, untilTime: filter.untilTime, timezone: timezoneOffsetString, page: filter.page, count: filter.count, group: filter.group.rawValue))
            .then {
                (response: Response) -> Promise<TransactionsPage> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessTransactionsGroupedSearchingResponse) -> Void = { s in
                            do {
                                let page = try TransactionsPage(codable: s.data)

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

                                        var newGroups: [TransactionsGroup] = []

                                        for (i, phones) in parsed.enumerated() {

                                            var newTransactions: [Transaction] = []

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

                                            let newGroup = TransactionsGroup(dateInterval: page.transactions[i].dateInterval,
                                                                                 amount: page.transactions[i].amount,
                                                                                 transactions: newTransactions)
                                            newGroups.append(newGroup)
                                        }

                                        let newPage = TransactionsPage(next: page.next, transactions: newGroups)

                                        DispatchQueue.main.async {
                                            seal.fulfill(newPage)
                                        }
                                    }
                                }
                            } catch let error {
                                seal.reject(error)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Get KYC personal info progress information.

     - parameter token: Current session's token.

     - returns: Approving status and sended data if it was.
     */
    func getKYCPersonalInfo(token: String) -> Promise<KYCPersonalInfo> {
        return provider.execute(UserRequest.getKYCPersonalInfo(token: token))
            .then {
                (response: Response) -> Promise<KYCPersonalInfo> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableKYCPersonalInfoResponse) -> Void = { s in
                            do {
                                let info = try KYCPersonalInfo(codable: s.data)
                                seal.fulfill(info)
                            } catch let e {
                                seal.reject(e)
                            }
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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

    /**
     Send KYC personal info data.

     - parameter token: Current session's token.
     - parameter personalData: All personal info properties.
     */
    func sendKYCPersonalInfo(token: String, personalData: KYCPersonaInfoProperties) -> Promise<Void> {
        return self.sendKYCPersonalInfo(token: token, email: personalData.email, firstName: personalData.firstName, lastName: personalData.lastName, birthDate: personalData.birthDate, gender: personalData.gender, country: personalData.country, city: personalData.city, region: personalData.region, street: personalData.street, house: personalData.house, postalCode: personalData.postalCode)
    }

    func sendKYCPersonalInfo(token: String, email: String, firstName: String, lastName: String, birthDate: Date, gender: GenderType, country: String, city: String, region: String, street: String, house: String, postalCode: Int) -> Promise<Void> {
        return provider.execute(UserRequest.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: String(Int(birthDate.unixTimestamp)), sex: gender.rawValue, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode))
            .then {
                (response: Response) -> Promise<Void> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableEmptyResponse) -> Void = { s in
                            seal.fulfill(())
                        }

                        let failure: (CodableWalletFailure) -> Void = { f in
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
