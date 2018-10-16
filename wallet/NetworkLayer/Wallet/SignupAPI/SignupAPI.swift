//
//  SignupAPI.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Signing up API. Provides requests for sending verification code to phone, verifing phone and providing password.
 */
struct SignupAPI: NetworkService, CreatePasswordProcess {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Start user account creation by sending verification code via SMS.
     */
    func sendVerificationCode(to phone: String, referrerPhone: String? = nil) -> Promise<Void> {
        return provider.execute(SignupRequest.start(phone: phone, referrerPhone: referrerPhone))
            .then {
                (response: Response) -> Promise<Void> in

                return Promise { seal in
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
                }
        }
    }

    /**
     Verifies user account by passing SMS Code which has been sent previously.
     */
    func verifyPhoneNumber(_ phone: String, withCode verificationCode: String) -> Promise<String> {
        return provider.execute(SignupRequest.verify(phone: phone, verificationCode: verificationCode))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSignupTokenResponse) -> Void = { s in
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
     Finish account creation by setting user password, this request requires SignUp Token.
     */
    func providePassword(_ password: String, confirmation: String, for phone: String, signupToken: String) -> Promise<String> {
        return provider.execute(SignupRequest.finish(phone: phone, signupToken: signupToken, password: password, passwordConfirmation: confirmation))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
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
                }
        }
    }
}
