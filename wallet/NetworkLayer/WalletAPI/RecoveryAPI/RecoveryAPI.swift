//
//  RecoveryAPI.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct RecoveryAPI: NetworkService {

    private let provider: RecoveryProvider

    init(provider: RecoveryProvider) {
        self.provider = provider
    }

    func sendVerificationCode(to phone: String) -> Promise<Void> {
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

    func verifyRecoveringAccountPassword(passing verificationCode: String, hasBeenSentTo phone: String) -> Promise<String> {
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

    func providePassword(_ password: String, confirmation: String, for phone: String, recoveryToken: String) -> Promise<String> {
        return provider.execute(.finish(phone: phone, recoveryToken: recoveryToken, newPassword: password, newPasswordConfirmation: confirmation))
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
}
