//
//  Response.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 Enum provides universal object to handle server response and work with it.
 */
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

    /**
     Extracting Codable 'success' or 'failure' object from response.

     Throws error if response can't be converted to provided types or if response object is '.error' (internal application error)

     - parameters:
        - success: Closure that calls if extracted object is Success object and provides this object
        - failure: Closure that calls if extracted object is Failure object and provides this object
     */
    func extractResult<Success: Codable, Failure: Codable>(success: (Success) -> Void, failure: (Failure) -> Void) throws {
        switch self {
        case .data(let data):
            let decoder = JSONDecoder()

            print("Data content: \(String(data: data, encoding: String.Encoding.utf8))")

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
