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

    func toCodable<Success: Codable, Failure: Codable>() throws -> (Success?, Failure?) {
        switch self {
        case .data(let d):
            let decoder = JSONDecoder()

            let success = try? decoder.decode(Success.self, from: d)
            let failure = try? decoder.decode(Failure.self, from: d)

            if success == nil, failure == nil {
                throw ResponseError.cantConvertToGivenCodable
            }

            return (success, failure)
        case .error(_):
            throw ResponseError.tryConvertErrorToCodable
        }
    }
}

enum ResponseError: Error {
    case invalidData
    case tryConvertErrorToCodable
    case cantConvertToGivenCodable
}
