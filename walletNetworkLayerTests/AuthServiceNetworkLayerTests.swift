//
//  AuthServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class AuthServiceNetworkLayerTests: XCTestCase {

    func testSigningInSucceed() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let token = "token"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: token)
        let responseCodable =  CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testSigningInFailure() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testSigningOutSucceed() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let responseCodable = CodableSuccessEmptyResponse(result: true)

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testSigningOutFailure() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testCheckingIfUserAuthorizedSucceed() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let phone = "+79999999999"
        let tokenCodable = CodableSuccessAuthorizedPhoneResponse.Phone(phone: phone)
        let responseCodable =  CodableSuccessAuthorizedPhoneResponse(result: true, data: tokenCodable)

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testCheckingIfUserAuthorizedFailure() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testConfirmingUserPhoneSucceed() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let newToken = "newToken"
        let tokenCodable = CodableSuccessAuthTokenResponse.Token(token: newToken)
        let responseCodable =  CodableSuccessAuthTokenResponse(result: true, data: tokenCodable)

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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

    func testConfirmingUserPhoneFailure() {
        // given
        // Create dispatcher mock and assign test succesful response data
        var dispatcher = DispatcherMock()

        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Encoding response to data
        let encoder = JSONEncoder()
        let data = try! encoder.encode(responseCodable)

        dispatcher.response = Response(reponse: nil, data: data, error: nil)

        // Create provider with dispatcher and environment mocks
        let provider = Provider(environment: EnvironmentMock(), dispatcher: dispatcher)

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
}
