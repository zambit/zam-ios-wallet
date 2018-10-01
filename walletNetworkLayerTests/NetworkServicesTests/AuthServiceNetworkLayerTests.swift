//
//  AuthServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

enum AuthServiceNetworkLayerStubs {
    case signIn
    case signOut
    case checkIfUserAuthorized
    case refreshToken
    case failure

    var resourceName: String {
        switch self {
        case .signIn:
            return "auth_signin"
        case .signOut:
            return "successful_empty_response"
        case .checkIfUserAuthorized:
            return "auth_check_authorized"
        case .refreshToken:
            return "auth_refresh_token"
        case .failure:
            return "fail_response"
        }
    }

    var failureObject: WalletResponseError? {
        switch self {
        case .failure:
            let error = "failure message"
            let name = "target"
            let input = "body"

            let codableError = CodableFailure.Error(name: name, input: input, message: error)
            let responseError = WalletResponseError.serverFailureResponse(errors: [codableError])
            return responseError
        default:
            return nil
        }
    }
}

class AuthServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `signIn(phone:password:)` method.
     */
    func testSigningInSucceed() {
        // given
        let stub = AuthServiceNetworkLayerStubs.signIn
        let comparingObject = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzAxMDMsImlhdCI6MTUzODE0MzcwMywiaWQiOjEwNywicGVyc2lzdEtleSI6IjIyOWI4NTFjLTM2YTItNDlmOS05NjVlLWJlZmFhNTkzMzlmYSIsInBob25lIjoiKzc5MTExMTExMTExIn0.6qiuEpHnZukwKH9kBvKIqecOSJga67LT-lixZNfLrHg"

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let phone = "+79111111111"
            let password = "password"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for signing in")

            authAPI.signIn(phone: phone, password: password).done {
                response in

                // then
                XCTAssertEqual(response, comparingObject)

                expectation.fulfill()
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test failed performance of `signIn(phone:password:)` method.
     */
    func testSigningInFailure() {
        // given
        let stub = AuthServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let phone = "+79111111111"
            let password = "password"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for signing in")

            authAPI.signIn(phone: phone, password: password).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                // then
                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `signOut(token:)` method.
     */
    func testSigningOutSucceed() {
        // given
        let stub = AuthServiceNetworkLayerStubs.signOut
        let comparingObject = true

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzAxMDMsImlhdCI6MTUzODE0MzcwMywiaWQiOjEwNywicGVyc2lzdEtleSI6IjIyOWI4NTFjLTM2YTItNDlmOS05NjVlLWJlZmFhNTkzMzlmYSIsInBob25lIjoiKzc5MTExMTExMTExIn0.6qiuEpHnZukwKH9kBvKIqecOSJga67LT-lixZNfLrHg"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for signing out")

            authAPI.signOut(token: token).done {
                // then
                XCTAssertTrue(comparingObject)

                expectation.fulfill()
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test failed performance of `signOut(token:)` method.
     */
    func testSigningOutFailure() {
        // given
        let stub = AuthServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for signing out")

            authAPI.signOut(token: token).done {
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                // then
                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `checkIfUserAuthorized(token:)` method.
     */
    func testCheckingIfUserAuthorizedSucceed() {
        // given
        let stub = AuthServiceNetworkLayerStubs.checkIfUserAuthorized
        let comparingObject = "+79111111111"

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for checking authorized")

            authAPI.checkIfUserAuthorized(token: token).done {
                response in
                //then
                XCTAssertEqual(response, comparingObject)

                expectation.fulfill()
            }.catch {
                _ in
                //then
                XCTFail("Response should be succeed, not failure")

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test failed performance of `checkIfUserAuthorized(token:)` method.
     */
    func testCheckingIfUserAuthorizedFailure() {
        // given
        let stub = AuthServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for checking authorized")

            authAPI.checkIfUserAuthorized(token: token).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                // then
                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `refreshToken(token:)` method.
     */
    func testRefreshingTokenSucceed() {
        // given
        let stub = AuthServiceNetworkLayerStubs.refreshToken
        let comparingObject = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzU2MDQsImlhdCI6MTUzODE0OTIwNCwiaWQiOjEwNywicGVyc2lzdEtleSI6IjY2YWRiOTFlLWM4NDMtNDI1Yi05ODRhLTg0NTM2MTIyOWEyNSIsInBob25lIjoiKzc5MTExMTExMTExIn0.hIA9iAUO9wx1WH35_qmy1VWHnjahKKos44SRnQH4EP0"

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for refreshing token")

            authAPI.refreshToken(token: token).done {
                response in

                // then
                XCTAssertEqual(response, comparingObject)

                expectation.fulfill()
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test failed performance of `refreshToken(token:)` method.
     */
    func testRefreshingTokenFailure() {
        // given
        let stub = AuthServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for refreshing token")

            authAPI.refreshToken(token: token).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                        XCTFail("Wrong fail response type")
                        return
                }

                // then
                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }
}
