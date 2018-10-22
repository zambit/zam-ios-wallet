//
//  HTTPDispatcher.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 This struct is default iOS network implementation using URLSession.
 */
struct HTTPDispatcher: Dispatcher {

    func dispatch(request: Request, with environment: Environment) -> Promise<Response> {
        return Promise { seal in
            do {
                let urlRequest = try prepareURLRequest(for: request, with: environment)

                print(urlRequest.url ?? "")
                print(String(data: urlRequest.httpBody ?? Data(), encoding: String.Encoding.utf8) ?? "")

                let task = self.session.dataTask(with: urlRequest) { data, response, error in

                    let response = Response(reponse: response, data: data, error: error)
                    seal.fulfill(response)
                }

                task.resume()
            } catch let e {
                seal.reject(e)
            }
        }
    }

    func cancelAllTasks() {
        session.getAllTasks {
            tasks in
            tasks.forEach { $0.cancel() }
        }
    }

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 35.0

        let session = URLSession(configuration: config)
        return session
    }()

    /**
     Prepare url request from Request and Environment objects.
     */
    private func prepareURLRequest(for request: Request, with environment: Environment) throws -> URLRequest {

        let fullURLString = "\(environment.host)/\(request.path)"

        guard let fullURL = URL(string: fullURLString) else {
            throw HTTPDispatcherError.badURL
        }

        var urlRequest = URLRequest(url: fullURL)

        guard var urlComponents = URLComponents(string: fullURLString) else {
            throw HTTPDispatcherError.badURL
        }

        // Add parameters from environment
        switch environment.parameters {
        case .body(let params)?:
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])

        case .url(let params)?:
            urlComponents.addQueryItems(params.map {
                return URLQueryItem(name: $0.key, value: $0.value)
            })

            urlRequest.url = urlComponents.url
        case .none:
            break
        }

        // Add parameters from request
        switch request.parameters {
        case .body(let params)?:
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])

        case .url(let params)?:
            urlComponents.addQueryItems(params.map {
                return URLQueryItem(name: $0.key, value: $0.value)
            })

            urlRequest.url = urlComponents.url
        case .none:
            break
        }

        // Add headers from environment
        guard let headers = environment.headers as? [String: String] else {
            throw HTTPDispatcherError.badInput
        }

        headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }


        // Add headers from request
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
}

enum HTTPDispatcherError: Error {
    case invalidURL
    case badInput
    case badURL
    case undefinedError
}
