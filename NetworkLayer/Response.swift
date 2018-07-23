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

    func toCodable<T: Codable>() throws -> T? {
        switch self {
        case .data(let d):
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: d)
            return value
        case .error(_):
            return nil
        }
    }
}

enum ResponseError: Error {
    case invalidData
}
