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
 Authorization process API. Provides requests for signing in, signing out, checking user authorization, confirming user phone with link and creating new user from pending transaction.
 */
struct AuthAPI: NetworkService {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Authorize user and get auth token, works only for full-verified user accounts
     */
    func signIn(phone: String, password: String) -> Promise<String> {
        return provider.execute(AuthRequest.signIn(phone: phone, password: password))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenResponse) -> Void = { s in
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
                }
        }
    }

    /**
     Invalidates user's current authorization session
     */
    @discardableResult
    func signOut(token: String) -> Promise<Void> {
        return provider.execute(AuthRequest.signOut(token: token))
            .then {
                (response: Response) -> Promise<Void> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessEmptyResponse) -> Void = { _ in
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

    /**
     Checks if user authorized, returns his phone on success
     */
    func checkIfUserAuthorized(token: String) -> Promise<String> {
        return provider.execute(AuthRequest.checkAuthorized(token: token))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):
                        
                        let success: (CodableSuccessAuthorizedPhoneResponse) -> Void = { s in
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
                }
        }
    }

    /**
     Confirm user phone
     */
    func confirmUserPhone(token: String, link: String) -> Promise<String> {
        return provider.execute(AuthRequest.confirmUserPhone(token: token, confirmationId: link))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenResponse) -> Void = { s in
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
                }
        }
    }

    /**
     Create new user from pending transaction
     */
    func createNewUserFromPendingTransaction(token: String, link: String) -> Promise <String> {
        return provider.execute(AuthRequest.createNewUserFromPendingTransaction(token: token, recvInvitationId: link))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenResponse) -> Void = { s in
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
                }
        }
    }

    func refreshToken(token: String) -> Promise<String> {
        return provider.execute(AuthRequest.refreshToken(token: token))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenResponse) -> Void = { s in
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
                }
        }
    }
}
