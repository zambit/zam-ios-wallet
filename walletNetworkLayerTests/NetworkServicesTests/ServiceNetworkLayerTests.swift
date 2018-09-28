//
//  ServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class ServiceNetworkLayerTests: XCTestCase {

    /**
     Build provider object with dispatcher mock with response loaded from local file.
     */
    final func buildProviderWith(resourceName: String) throws -> Provider {
        let data = try StubsLoader.loadData(from: resourceName)

        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

        return provider
    }

    /**
     Build provider object with dispatcher mock that returns 'response'.
     */
    final func buildProviderWith<R: Codable>(response: R) -> Provider {
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(response)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

        return provider
    }

}
