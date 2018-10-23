//
//  SigninAPI.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 * Authorization process API. Provides requests for signing in, signing out,
 * checking user authorization, confirming user phone with link and refreshing token.
 */
struct AuthAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Authorize user and get auth token, works only for full-verified user accounts.

     - parameter phone: Account's phone.
     - parameter password: Account's password.

     - returns: Token.
     */
    func signIn(phone: String, password: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.signIn(phone: phone, password: password)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableTokenResponse) -> Void = { s in
                        seal.fulfill(s.data.token)
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    /**
     Invalidates user's current authorization session

     - parameter token: Current session's token.
     */
    @discardableResult
    func signOut(token: String) -> Promise<Void> {
        return Promise { seal in
            let request = AuthRequest.signOut(token: token)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableEmptyResponse) -> Void = { _ in
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    /**
     Checks if user authorized, returns his phone on success.

     - parameter token: Current session's token.

     - returns: User's phone number.
     */
    func checkIfUserAuthorized(token: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.checkAuthorized(token: token)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodablePhoneResponse) -> Void = { s in
                        seal.fulfill(s.data.phone)
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    /**
     Confirm user's phone.

     - parameter token: Current session's token.
     - parameter link: -

     - returns: Token.
     */
    func confirmUserPhone(token: String, link: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.confirmUserPhone(token: token, confirmationId: link)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableTokenResponse) -> Void = { s in
                        seal.fulfill(s.data.token)
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    /**
     Create new user from pending transaction.
     */
    func createNewUserFromPendingTransaction(token: String, link: String) -> Promise <String> {
        return Promise { seal in
            let request = AuthRequest.createNewUserFromPendingTransaction(token: token, recvInvitationId: link)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableTokenResponse) -> Void = { s in
                        seal.fulfill(s.data.token)
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }

    /**
     Refresh current unexpired existing token.

     - parameter token: Current session's token.

     - returns: Token.
     */
    func refreshToken(token: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.refreshToken(token: token)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableTokenResponse) -> Void = { s in
                        seal.fulfill(s.data.token)
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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
}
