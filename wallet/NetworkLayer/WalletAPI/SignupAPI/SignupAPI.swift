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
                    case .data(let data):
                        do {
                            let responsedObject: (CodableSuccessEmptyData?, CodableFailure?) = try response.toCodable()

                            if let _ = responsedObject.0 {
                                seal.fulfill(())
                            }

                            if let fail = responsedObject.1 {



                            }

                        } catch let e {
                            seal.reject(e)
                        }

//                        print(String(data: data, encoding: String.Encoding.utf8))
//
//                        do {
//                            let json = try JSON(data: data, options: .allowFragments)
//                            let object = try Success(with: json)
//                        } catch let e {
//                            print(e)
//                        }

                        seal.reject(CodableError.internalCodableConvertionFailure)
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

struct Success: JSONInitializable {
    let result: Bool

    init(with json: JSON) throws {
        print(json)
        self.result = json["result"].boolValue
    }
}


