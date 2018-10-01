//
//  SignUpServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

enum SignUpServiceNetworkLayerStubs {
    case sendVerificationCode
    case verifyPhoneNumber
    case providePassword
    case failure

    var resourceName: String {
        switch self {
        case .sendVerificationCode:
            return "successful_empty_response"
        case .verifyPhoneNumber:
            return "signup_verify_phone"
        case .providePassword:
            return "signup_provide_password"
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

class SignUpServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `sendVerificationCode(to:referrerPhone:)` method.
     */
    func testSendingVerificationCodeSucceed() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.sendVerificationCode

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let phone = "+79111111111"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for sending verification code")

            signupAPI.sendVerificationCode(to: phone).done {
                // then
                XCTAssertTrue(true)

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
     Test failed performance of `sendVerificationCode(to:referrerPhone:)` method.
     */
    func testSendingVerificationCodeFailure() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let phone = "+79111111111"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for sending verification code")

            signupAPI.sendVerificationCode(to: phone).done {
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
     Test succeed performance of `verifyPhoneNumber(:withCode:)` method.
     */
    func testVerifyingPhoneNumberSucceed() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.verifyPhoneNumber
        let comparingObject = "9f55c6b531e841ddb2cfa68f4eea2b5a"

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let phone = "+79111111111"
            let code = "123456"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for verifying phone number")

            signupAPI.verifyPhoneNumber(phone, withCode: code).done {
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
     Test failed performance of `verifyPhoneNumber(:withCode:)` method.
     */
    func testVerifyingPhoneNumberFailure() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let phone = "+79111111111"
            let code = "123456"

            //when
            let expectation = XCTestExpectation(description: "Test fail responsing for verifying phone number")

            signupAPI.verifyPhoneNumber(phone, withCode: code).done {
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
     Test succeed performance of `providePassword(:confirmation:for:recoveryToken:)` method.
     */
    func testProvidingPasswordSucceed() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.providePassword
        let comparingObject = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1Mzg0ODQ1NDgsImlhdCI6MTUzODM5ODE0OCwiaWQiOjEwOSwicGVyc2lzdEtleSI6IjE1Njk2ODUwLTM3MDktNGYzYy1iNWJkLTBhZmVjZjVhNjU0ZCIsInBob25lIjoiKzc5NTY1NjU1NjU2In0.V0fHuAUCqjVTd15ck8hJujZnjeYlqeDc3zU9sxHgP3k"

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let password = "123456"
            let confirmation = "123456"
            let phone = "+79111111111"
            let token = "d97ece27be1c42b4984fd7de08bb8de0"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for providing password")

            signupAPI.providePassword(password, confirmation: confirmation, for: phone, signupToken: token).done {
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
     Test failed performance of `providePassword(:confirmation:for:recoveryToken:)` method.
     */
    func testProvidingPasswordFailure() {
        // given
        let stub = SignUpServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let signupAPI = SignupAPI(provider: provider)

            let password = "123456"
            let confirmation = "123456"
            let phone = "+79111111111"
            let token = "d97ece27be1c42b4984fd7de08bb8de0"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for providing password")

            signupAPI.providePassword(password, confirmation: confirmation, for: phone, signupToken: token).done {
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
