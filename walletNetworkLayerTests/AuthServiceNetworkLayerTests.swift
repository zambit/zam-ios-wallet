//
//  AuthServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class AuthServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `signIn(phone:password:)` method.
     */
    func testSigningInSucceed() {
        // given
        // Construct response codable object
        let token = "token"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: token)
        let responseCodable =  CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let phone = "+79999999999"
        let password = "password"

        //when
        authAPI.signIn(phone: phone, password: password).done {
            response in

            // then
            XCTAssertEqual(token, response)
        }.catch {
            _ in
            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `signIn(phone:password:)` method.
     */
    func testSigningInFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let phone = "+79999999999"
        let password = "password"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        authAPI.signIn(phone: phone, password: password).done {
            response in

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
     Test succeed performance of `signOut(token:)` method.
     */
    func testSigningOutSucceed() {
        // given
        // Construct response codable object
        let responseCodable = CodableSuccessEmptyResponse(result: true)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let token = "token"

        //when
        authAPI.signOut(token: token).done {

            // then
            XCTAssert(true)
        }.catch {
            _ in

            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `signOut(token:)` method.
     */
    func testSigningOutFailure() {
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
        authAPI.signOut(token: token).done {
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
     Test succeed performance of `checkIfUserAuthorized(token:)` method.
     */
    func testCheckingIfUserAuthorizedSucceed() {
        // given
        // Construct response codable object
        let phone = "+79999999999"
        let tokenCodable = CodableSuccessAuthorizedPhoneResponse.Phone(phone: phone)
        let responseCodable =  CodableSuccessAuthorizedPhoneResponse(result: true, data: tokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let token = "token"

        //when
        authAPI.checkIfUserAuthorized(token: token).done {
            response in
            //then
            XCTAssertEqual(phone, response)
        }.catch {
            _ in
            //then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `checkIfUserAuthorized(token:)` method.
     */
    func testCheckingIfUserAuthorizedFailure() {
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
        authAPI.checkIfUserAuthorized(token: token).done {
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
        // Construct response codable object
        let refreshToken = "refreshToken"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: refreshToken)
        let responseCodable =  CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let authAPI = AuthAPI(provider: provider)

        let token = "token"

        //when
        authAPI.refreshToken(token: token).done {
            response in
            //then
            XCTAssertEqual(refreshToken, response)
        }.catch {
            _ in
            //then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `refreshToken(token:)` method.
     */
    func testRefreshingTokenFailure() {
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
        authAPI.refreshToken(token: token).done {
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
