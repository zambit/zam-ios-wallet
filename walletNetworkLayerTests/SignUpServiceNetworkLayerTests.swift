//
//  SignUpServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class SignUpServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `sendVerificationCode(to:referrerPhone:)` method.
     */
    func testSendingVerificationCodeSucceed() {
        // given
        // Construct response codable object
        let responseCodable = CodableSuccessEmptyResponse(result: true)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let phone = "+79999999999"

        //when
        signupAPI.sendVerificationCode(to: phone).done {
            // then
            XCTAssertTrue(true)
        }.catch {
            _ in
            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `sendVerificationCode(to:referrerPhone:)` method.
     */
    func testSendingVerificationCodeFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let phone = "+79999999999"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        signupAPI.sendVerificationCode(to: phone).done {
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
     Test succeed performance of `verifyPhoneNumber(:withCode:)` method.
     */
    func testVerifyingPhoneNumberSucceed() {
        // given
        // Construct response codable object
        let token = "signupToken"
        let signupTokenCodable = CodableSuccessSignUpTokenResponse.SignupToken(token: token)
        let responseCodable = CodableSuccessSignUpTokenResponse(result: true, data: signupTokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let phone = "+79999999999"
        let code = "123456"

        //when
        signupAPI.verifyPhoneNumber(phone, withCode: code).done {
            response in
            // then
            XCTAssertEqual(response, token)
        }.catch {
            _ in
            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `verifyPhoneNumber(:withCode:)` method.
     */
    func testVerifyingPhoneNumberFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let phone = "+79999999999"
        let code = "123456"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        signupAPI.verifyPhoneNumber(phone, withCode: code).done {
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
     Test succeed performance of `providePassword(:confirmation:for:recoveryToken:)` method.
     */
    func testProvidingPasswordSucceed() {
        // given
        // Construct response codable object
        let token = "token"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: token)
        let responseCodable = CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let password = "123456"
        let confirmation = "123456"
        let phone = "+79999999999"
        let signupToken = "signupToken"

        //when
        signupAPI.providePassword(password, confirmation: confirmation, for: phone, signupToken: signupToken).done {
            response in
            // then
            XCTAssertEqual(response, token)
        }.catch {
            _ in
            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `providePassword(:confirmation:for:recoveryToken:)` method.
     */
    func testProvidingPasswordFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let signupAPI = SignupAPI(provider: provider)

        let password = "123456"
        let confirmation = "123456"
        let phone = "+79999999999"
        let signupToken = "signupToken"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        signupAPI.providePassword(password, confirmation: confirmation, for: phone, signupToken: signupToken).done {
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
}
