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
            return "auth_signout"
        case .checkIfUserAuthorized:
            return "auth_check_authorized"
        case .refreshToken:
            return "auth_refresh_token"
        case .failure:
            return "fail_response"
        }
    }

    var comparingObject: Any? {
        switch self {
        case .signIn:
            return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzAxMDMsImlhdCI6MTUzODE0MzcwMywiaWQiOjEwNywicGVyc2lzdEtleSI6IjIyOWI4NTFjLTM2YTItNDlmOS05NjVlLWJlZmFhNTkzMzlmYSIsInBob25lIjoiKzc5MTExMTExMTExIn0.6qiuEpHnZukwKH9kBvKIqecOSJga67LT-lixZNfLrHg"
        case .signOut:
            return nil
        case .checkIfUserAuthorized:
            return "+79111111111"
        case .refreshToken:
            return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzU2MDQsImlhdCI6MTUzODE0OTIwNCwiaWQiOjEwNywicGVyc2lzdEtleSI6IjY2YWRiOTFlLWM4NDMtNDI1Yi05ODRhLTg0NTM2MTIyOWEyNSIsInBob25lIjoiKzc5MTExMTExMTExIn0.hIA9iAUO9wx1WH35_qmy1VWHnjahKKos44SRnQH4EP0"
        case .failure:
            let error = "failure message"
            let name = "target"
            let input = "body"

            let codableError = CodableFailure.Error(name: name, input: input, message: error)
            let responseError = WalletResponseError.serverFailureResponse(errors: [codableError])
            return responseError
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

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let phone = "+79111111111"
            let password = "password"

            //when
            authAPI.signIn(phone: phone, password: password).done {
                response in

                // then
                XCTAssertEqual(response, stub.comparingObject as! String)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
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
            authAPI.signIn(phone: phone, password: password).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")
            }.catch {
                e in

                guard
                    let response = e as? WalletResponseError,
                    let comparing = stub.comparingObject as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                XCTAssertEqual(response, comparing)
            }
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

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MzgyMzAxMDMsImlhdCI6MTUzODE0MzcwMywiaWQiOjEwNywicGVyc2lzdEtleSI6IjIyOWI4NTFjLTM2YTItNDlmOS05NjVlLWJlZmFhNTkzMzlmYSIsInBob25lIjoiKzc5MTExMTExMTExIn0.6qiuEpHnZukwKH9kBvKIqecOSJga67LT-lixZNfLrHg"

            //when
            authAPI.signOut(token: token).done {
                // then
                XCTAssert(stub.comparingObject == nil)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
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
            authAPI.signOut(token: token).done {
                // then
                XCTFail("Response should be a failure, not success")
            }.catch {
                e in

                guard
                    let response = e as? WalletResponseError,
                    let comparing = stub.comparingObject as? WalletResponseError else {
                        XCTFail("Wrong fail response type")
                        return
                }

                XCTAssertEqual(response, comparing)
            }
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

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            authAPI.checkIfUserAuthorized(token: token).done {
                response in
                //then
                XCTAssertEqual(response, stub.comparingObject as! String)
            }.catch {
                _ in
                //then
                XCTFail("Response should be succeed, not failure")
            }
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
            authAPI.checkIfUserAuthorized(token: token).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")
            }.catch {
                e in

                guard
                    let response = e as? WalletResponseError,
                    let comparing = stub.comparingObject as? WalletResponseError else {
                        XCTFail("Wrong fail response type")
                        return
                }

                XCTAssertEqual(response, comparing)
            }
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `confirmUserPhone(token:link:)` method.
     */
    func testConfirmingUserPhoneSucceed() {
        // given
        // Construct response codable object
        let newToken = "newToken"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: newToken)
        let responseCodable =  CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let token = "token"

        //when
        authAPI.confirmUserPhone(token: token, link: "").done {
            response in
            //then
            XCTAssertEqual(newToken, response)
        }.catch {
            _ in
            //then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `confirmUserPhone(token:link:)` method.
     */
    func testConfirmingUserPhoneFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        authAPI.confirmUserPhone(token: token, link: "").done {
            _ in
            // then
            XCTFail("Response should be a failure, not success")
        }.catch {
            e in

            guard let response = e as? WalletResponseError else {
                XCTFail("Wrong fail response type")
                return
            }

            switch response {
            case .serverFailureResponse(errors: let errors):
                // then
                let error = errors.first
                XCTAssertEqual(expectedResponse, error)
            case .undefinedServerFailureResponse:
                // then
                XCTFail("Wrong fail response type")
            }
        }
    }

    /**
     Test succeed performance of `refreshToken(token:)` method.
     */
    func testRefreshingTokenSucceed() {
        // given
        let stub = AuthServiceNetworkLayerStubs.refreshToken

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let authAPI = AuthAPI(provider: provider)

            let token = "token"

            //when
            authAPI.refreshToken(token: token).done {
                response in

                // then
                XCTAssertEqual(response, stub.comparingObject as! String)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
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
            authAPI.refreshToken(token: token).done {
                _ in
                // then
                XCTFail("Response should be a failure, not success")
            }.catch {
                e in

                guard
                    let response = e as? WalletResponseError,
                    let comparing = stub.comparingObject as? WalletResponseError else {
                        XCTFail("Wrong fail response type")
                        return
                }

                XCTAssertEqual(response, comparing)
            }
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }
}
