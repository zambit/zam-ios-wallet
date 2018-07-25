//
//  SigninAPI.swift
//  wallet
//
//  Created by  me on 25/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct AuthAPI: NetworkService {

    private let provider: AuthProvider

    init(provider: AuthProvider) {
        self.provider = provider
    }

    func signIn(phone: String, password: String) -> Promise<String> {
        return provider.execute(.signIn(phone: phone, password: password))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenData) -> Void = { s in
                            seal.fulfill(s.data.token)
                        }

                        let failure: (CodableFailure) -> Void = { f in
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

    func signOut(token: String) -> Promise<Bool> {
        return provider.execute(.signOut(token: token))
            .then {
                (response: Response) -> Promise<Bool> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessEmptyData) -> Void = { _ in
                            seal.fulfill(true)
                        }

                        let failure: (CodableFailure) -> Void = { f in
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

    func checkIfUserAuthorized(token: String) -> Promise<String> {
        return provider.execute(.checkAuthorized(token: token))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):
                        
                        let success: (CodableSuccessAuthorizedPhoneData) -> Void = { s in
                            seal.fulfill(s.data.phone)
                        }

                        let failure: (CodableFailure) -> Void = { f in
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

    func confirmUserPhone(token: String, link: String) -> Promise<String> {
        return provider.execute(.confirmUserPhone(token: token, confirmationId: link))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenData) -> Void = { s in
                            seal.fulfill(s.data.token)
                        }

                        let failure: (CodableFailure) -> Void = { f in
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

    func createNewUserFromPendingTransaction(token: String, link: String) -> Promise <String> {
        return provider.execute(.createNewUserFromPendingTransaction(token: token, recvInvitationId: link))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessAuthTokenData) -> Void = { s in
                            seal.fulfill(s.data.token)
                        }

                        let failure: (CodableFailure) -> Void = { f in
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
