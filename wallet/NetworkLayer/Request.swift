//
//  Request.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

protocol Request {

    var path: String { get }

    var method: HTTPMethod { get }

    var parameters: RequestParams { get }

    var headers: [String: Any]? { get }
}

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

enum RequestParams {
    case body([String: String]?)
    case url([String: String]?)
}
