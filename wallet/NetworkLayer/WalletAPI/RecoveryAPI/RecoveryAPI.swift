//
//  RecoveryAPI.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Recovery password API. Provides requests for sending verification code to phone, verifing recovering account password and providing new password.
 */
struct RecoveryAPI: NetworkService, ThreeStepsAPI {

    private let provider: RecoveryProvider

    init(provider: RecoveryProvider) {
        self.provider = provider
    }

    /**
     Start user password recovery by sending verification code via SMS.
     */
    func sendVerificationCode(to phone: String, referrerPhone: String? = nil) -> Promise<Void> {
        return provider.execute(.start(phone: phone))
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
     Verifies user password recovery by passing SMS Code which has been sent previously.
     */
    func verifyPhoneNumber(_ phone: String, withCode verificationCode: String) -> Promise<String> {
        return provider.execute(.verify(phone: phone, verificationCode: verificationCode))
            .then {
                (response: Response) -> Promise<String> in

                return Promise { seal in
                    switch response {
                    case .data(_):

                        let success: (CodableSuccessRecoveryTokenData) -> Void = { s in
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
     Finish password recovery by setting user password, this request requires Recovery Token.
     */
    func providePassword(_ password: String, confirmation: String, for phone: String, token: String) -> Promise<String> {
        return provider.execute(.finish(phone: phone, recoveryToken: token, newPassword: password, newPasswordConfirmation: confirmation))
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
