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
struct RecoveryAPI: NetworkService, CreatePasswordProcess {

    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    /**
     Start user password recovery by sending verification code via SMS.
     */
    func sendVerificationCode(to phone: String, referrerPhone: String? = nil) -> Promise<Void> {
        return Promise { seal in
            let request = RecoveryRequest.start(phone: phone)
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
     Verifies user password recovery by passing SMS Code which has been sent previously.
     */
    func verifyPhoneNumber(_ phone: String, withCode verificationCode: String) -> Promise<String> {
        return Promise { seal in
            let request = RecoveryRequest.verify(phone: phone, verificationCode: verificationCode)
            provider.execute(request).done {
                response in

                switch response {
                case .data(_):

                    let success: (CodableRecoveryTokenResponse) -> Void = { s in
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
     Finish password recovery by setting user password, this request requires Recovery Token.
     */
    func providePassword(_ password: String, confirmation: String, for phone: String, recoveryToken: String) -> Promise<Void> {
        return Promise { seal in
            let request = RecoveryRequest.finish(phone: phone,
                                                 recoveryToken: recoveryToken,
                                                 newPassword: password,
                                                 newPasswordConfirmation: confirmation)
            provider.execute(request).done {
                response in

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
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
}
