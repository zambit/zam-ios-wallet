//
//  walletNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class walletNetworkLayerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessfulResponse() {
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()
        let data = Data(bytes: [0, 1, 0, 1])
        dispatcher.response = Response(reponse: nil, data: data, error: nil)


        let expectedResponse: Response? = Response.data(data)
        dispatcher.dispatch(request: RequestMock(), with: EnvironmentMock()).done {
            response in

            XCTAssertEqual(response, expectedResponse)
        }.catch {
            _ in

            XCTFail()
        }
    }

    func testFailureResponse() {
        // Create dispatcher mock and assign test failure response data
        var dispatcher = DispatcherMock()
        let error = walletNetworkLayerTestsError.responseError
        dispatcher.response = Response(reponse: nil, data: nil, error: error)

        let expectedResponse: Response? = Response.error(error)
        dispatcher.dispatch(request: RequestMock(), with: EnvironmentMock()).done {
            response in

            XCTAssertEqual(response, expectedResponse)
        }.catch {
            _ in

            XCTFail()
        }
    }
}

enum walletNetworkLayerTestsError: Error {
    case responseError
}
