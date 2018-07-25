//
//  Response.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

enum Response {
    case data(Data)
    case error(Error)

    init(reponse: URLResponse?, data: Data?, error: Error?) {
        if let e = error {
            self = .error(e)
            return
        }

        if let d = data {
            self = .data(d)
            return
        }

        self = .error(ResponseError.invalidData)
    }

    func toCodable<Object: Codable>() throws -> Object {
        switch self {
        case .data(let d):
            let decoder = JSONDecoder()
            let object = try decoder.decode(Object.self, from: d)

            return object
        case .error(_):
            throw ResponseError.tryConvertApplicationErrorToCodable
        }
    }

    func extractResult<Success: Codable, Failure: Codable>(success: (Success) -> Void, failure: (Failure) -> Void) throws {
        switch self {
        case .data(let data):
            let decoder = JSONDecoder()

            do {
                let fail = try decoder.decode(Failure.self, from: data)
                failure(fail)
                return
            } catch let f {
                do {
                    let suc = try decoder.decode(Success.self, from: data)
                    success(suc)
                } catch let s {
                    throw ResponseError.responseDoesntCorrespondsToSuccessAndFailureTypes(successError: s, failureError: f)
                }
            }
        case .error(_):
            throw ResponseError.tryConvertApplicationErrorToCodable
        }
    }
}

enum ResponseError: Error {
    case invalidData
    case tryConvertApplicationErrorToCodable
    case cantConvertToGivenCodable
    case responseDoesntCorrespondsToSuccessAndFailureTypes(successError: Error, failureError: Error)
}
