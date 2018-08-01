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
struct SignupAPI: NetworkService, ThreeStepsAPI {

    private let provider: SignupProvider

    init(provider: SignupProvider) {
        self.provider = provider
    }

    /**
     Start user account creation by sending verification code via SMS.
     */
    func sendVerificationCode(to phone: String, referrerPhone: String? = nil) -> Promise<Void> {
        return provider.execute(.start(phone: phone, referrerPhone: referrerPhone))
            .then {
                (response: Response) -> Promise<Void> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessEmptyData) -> Void = { _ in
                            seal.fulfill(())
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

    /**
     Verifies user account by passing SMS Code which has been sent previously.
     */
    func verifyPhoneNumber(_ phone: String, withCode verificationCode: String) -> Promise<String> {
        return provider.execute(.verify(phone: phone, verificationCode: verificationCode))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessSignUpTokenData) -> Void = { s in
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

    /**
     Finish account creation by setting user password, this request requires SignUp Token.
     */
    func providePassword(_ password: String, confirmation: String, for phone: String, token: String) -> Promise<String> {
        return provider.execute(.finish(phone: phone, signupToken: token, password: password, passwordConfirmation: confirmation))
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
