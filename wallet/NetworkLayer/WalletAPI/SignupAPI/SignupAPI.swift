//
//  SignupAPI.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

struct SignupAPI: NetworkService {

    private let provider: SignupProvider

    init(provider: SignupProvider) {
        self.provider = provider
    }

    func sendVerificationCode(to phone: String, additional: String? = nil) -> Promise<Void> {
        return provider.execute(.start(phone: phone, referrerPhone: additional))
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

    func verifyUserAccount(passing verificationCode: String, hasBeenSentTo phone: String) {

    }

    func providePassword(_ password: String, confirmation: String, for phone: String, signUpToken: String) {

    }
}

enum VerififactionError: Error {
    case codableInternalError
    case wrongParametres
    case userAlreadyExists
    case referrerNotFound
    case internalServerError
}


