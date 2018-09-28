//
//  RecoveryServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class RecoveryServiceNetworkLayerTests: ServiceNetworkLayerTests {

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
        let recoveryAPI = RecoveryAPI(provider: provider)

        let phone = "+79999999999"

        //when
        recoveryAPI.sendVerificationCode(to: phone).done {
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
        let recoveryAPI = RecoveryAPI(provider: provider)

        let phone = "+79999999999"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        recoveryAPI.sendVerificationCode(to: phone).done {
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
        let token = "token"
        let recoveryTokenCodable = CodableSuccessRecoveryTokenResponse.RecoveryToken(token: token)
        let responseCodable = CodableSuccessRecoveryTokenResponse(result: true, data: recoveryTokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let recoveryAPI = RecoveryAPI(provider: provider)

        let phone = "+79999999999"
        let code = "123456"

        //when
        recoveryAPI.verifyPhoneNumber(phone, withCode: code).done {
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
        let recoveryAPI = RecoveryAPI(provider: provider)

        let phone = "+79999999999"
        let code = "123456"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        recoveryAPI.verifyPhoneNumber(phone, withCode: code).done {
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
        let responseCodable = CodableSuccessEmptyResponse(result: true)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let recoveryAPI = RecoveryAPI(provider: provider)

        let password = "123456"
        let confirmation = "123456"
        let phone = "+79999999999"
        let token = "token"

        //when
        recoveryAPI.providePassword(password, confirmation: confirmation, for: phone, recoveryToken: token).done {
            // then
            XCTAssertTrue(true)
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
        let recoveryAPI = RecoveryAPI(provider: provider)

        let password = "123456"
        let confirmation = "123456"
        let phone = "+79999999999"
        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        recoveryAPI.providePassword(password, confirmation: confirmation, for: phone, recoveryToken: token).done {
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
