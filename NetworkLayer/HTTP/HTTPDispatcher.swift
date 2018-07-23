//
//  HTTPDispatcher.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct HTTPDispatcher: Dispatcher {

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        return URLSession(configuration: config)
    }()

    private func prepareURLRequest(for request: Request, with environment: Environment) throws -> URLRequest {

        let fullURLString = "\(environment.host)/\(request.path)"

        guard let fullURL = URL(string: fullURLString) else {
            throw HTTPDispatcherError.badURL
        }

        var urlRequest = URLRequest(url: fullURL)

        switch request.parameters {
        case .body(let params):
            let encoder = JSONEncoder()
            urlRequest.httpBody = try encoder.encode(params)

        case .url(let params):
            guard var components = URLComponents(string: fullURLString) else {
                throw HTTPDispatcherError.badURL
            }

            components.queryItems = params?.map {
                return URLQueryItem(name: $0.key, value: $0.value)
            }

            urlRequest.url = components.url
        }

        // Add headers from provider and request
        guard let headers = environment.headers as? [String: String] else {
            throw HTTPDispatcherError.badInput
        }

        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        if let requestHeaders = request.headers {
            guard let requestHeaders = requestHeaders as? [String: String] else {
                throw HTTPDispatcherError.badInput
            }

            requestHeaders.forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }

        // Setup HTTP method
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }

    func dispatch(request: Request, with environment: Environment) -> Response {

    }
}

enum HTTPDispatcherError: Error {
    case invalidURL
    case badInput
    case badURL
    case undefinedError
}
