//
//  ProviderNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class ProviderNetworkLayerTests: XCTestCase {

    func testSuccessfulResponse() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()
        let data = Data(bytes: [0, 1, 0, 1])
        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

        // when
        let expectedResponse: Response? = Response.data(data)
        provider.execute(RequestMock()).done {
            response in

            // then
            XCTAssertEqual(response, expectedResponse)
        }.catch {
            _ in
             // then
            XCTFail()
        }
    }

    func testFailureResponse() {
        // given
        // Create dispatcher mock and assign test failure response data
        var dispatcher = DispatcherMock()
        let error = DispatcherNetworkLayerTestsError.responseError
        dispatcher.response = Response(reponse: nil, data: nil, error: error)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

        // when
        let expectedResponse: Response? = Response.error(error)
        provider.execute(RequestMock()).done {
            response in
            // Assert
            XCTAssertEqual(response, expectedResponse)
        }.catch {
            _ in

            XCTFail()
        }
    }
}

enum DispatcherNetworkLayerTestsError: Error {
    case responseError
}
