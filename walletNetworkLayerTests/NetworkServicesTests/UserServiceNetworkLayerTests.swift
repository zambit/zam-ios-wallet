//
//  UserServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

class UserServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `getUserInfo(token: coin:)` method.
     */
    func testGettingUserInfoSucceed() {
        // given
        // Construct response codable object
        let codableBalance = CodableBalance(zam: nil, eth: nil, btc: "32543.0", bch: nil, usd: "32543.0")
        let walletsCodable = CodableUser.CodableWallets(count: 0, totalBalance: codableBalance)
        let userCodable = CodableUser(id: "0", phone: "+79999999999", status: "status", registeredAt: 12345678, wallets: walletsCodable)
        let responseCodable =  CodableSuccessUserInfoResponse(result: true, data: userCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = try UserData(codable: userCodable)
            userAPI.getUserInfo(token: token, coin: nil).done {
                response in

                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating UserData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `getUserInfo(token:coin:)` method.
     */
    func testGettingUserInfoFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.getUserInfo(token: token, coin: nil).done {
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
     Test failed performance of `createWallet(token:coin:walletName:)` method.
     */
    func testCreatingWalletSucceed() {
        // given
        // Construct response codable object
        let coinType = CoinType.btc
        let walletName = "Name"

        let balanceCodable = CodableBalance(zam: nil, eth: nil, btc: "32543.0", bch: nil, usd: "32543.0")
        let walletCodable = CodableWallet(id: "0", coin: coinType.rawValue, name: walletName, address: "test", balances: balanceCodable)
        let walletPage = CodableSuccessWalletResponse.WalletPage(wallet: walletCodable)
        let responseCodable = CodableSuccessWalletResponse(result: true, data: walletPage)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = try WalletData(codable: walletCodable)
            userAPI.createWallet(token: token, coin: coinType, walletName: walletName).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating WalletData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `createWallet(token:coin:walletName:)` method.
     */
    func testCreatingWalletFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let coinType = CoinType.btc
        let walletName = "Name"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.createWallet(token: token, coin: coinType, walletName: walletName).done {
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
     Test succeed performance of `getWallets(token:coin:id:page:count:)` method.
     */
    func testGettingWalletsSucceed() {
        // given
        // Construct response codable object
        let balanceCodable = CodableBalance(zam: nil, eth: nil, btc: "32543.0", bch: nil, usd: "32543.0")
        let walletCodable = CodableWallet(id: "0", coin: CoinType.btc.rawValue, name: "Name", address: "test", balances: balanceCodable)
        let walletPage = CodableSuccessWalletsPageResponse.WalletsPage(count: 1, next: "", wallets: [walletCodable])
        let responseCodable = CodableSuccessWalletsPageResponse(result: true, data: walletPage)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = [try WalletData(codable: walletCodable)]
            userAPI.getWallets(token: token).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating WalletData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `getWallets(token:coin:id:page:count:)` method.
     */
    func testGettingWalletsFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.getWallets(token: token).done {
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
     Test succeed performance of `getWalletInfo(token:walletId:)` method.
     */
    func testGettingWalletInfoSucceed() {
        // given
        // Construct response codable object
        let walletId = "0"

        let balanceCodable = CodableBalance(zam: nil, eth: nil, btc: "32543.0", bch: nil, usd: "32543.0")
        let walletCodable = CodableWallet(id: walletId, coin: CoinType.btc.rawValue, name: "Name", address: "test", balances: balanceCodable)
        let walletPage = CodableSuccessWalletResponse.WalletPage(wallet: walletCodable)
        let responseCodable = CodableSuccessWalletResponse(result: true, data: walletPage)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = try WalletData(codable: walletCodable)
            userAPI.getWalletInfo(token: token, walletId: walletId).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating WalletData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `getWalletInfo(token:walletId:)` method.
     */
    func testGettingWalletInfoFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let walletId = "0"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.getWalletInfo(token: token, walletId: walletId).done {
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
     Test succeed performance of `sendTransaction(token:walletId:recipient:amount:)` method.
     */
    func testSendingTransactionSucceed() {
        // given
        // Construct response codable object
        let recipient = "+79999999999"
        let amount: Decimal = 942.56

        let balanceCodable = CodableBalance(zam: nil, eth: nil, btc: NumberFormatter.output.string(from: amount as NSNumber)!, bch: nil, usd: "32543.0")
        let transactionCodable = CodableTransaction(id: "1", direction: DirectionType.outgoing.rawValue, status: TransactionStatus.success.rawValue, coin: CoinType.btc.rawValue, sender: nil, recipient: recipient, amount: balanceCodable)
        let transactionResponseCodable = CodableSuccessTransactionResponse.Transaction(transaction: transactionCodable)
        let responseCodable = CodableSuccessTransactionResponse(result: true, data: transactionResponseCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let walletId = "0"

        //when
        do {
            let expectedResponse = try TransactionData(codable: transactionCodable)
            userAPI.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating TransactionData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `sendTransaction(token:walletId:recipient:amount:)` method.
     */
    func testSendingTransactionFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let walletId = "0"
        let recipient = "+79999999999"
        let amount: Decimal = 942.56

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount).done {
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
     Test succeed performance of `getTransactions(token:filter:phoneNumberFormatter:localContacts:)` method.
     */
    func tesGettingTransactionsSucceed() {
        // given
        // Construct response codable object
        let recipient = "+79999999999"
        let amount: Decimal = 942.56

        let balanceCodable = CodableBalance(zam: nil, eth: nil, btc: NumberFormatter.output.string(from: amount as NSNumber)!, bch: nil, usd: "32543.0")
        let transactionCodable = CodableTransaction(id: "1", direction: DirectionType.outgoing.rawValue, status: TransactionStatus.success.rawValue, coin: CoinType.btc.rawValue, sender: nil, recipient: recipient, amount: balanceCodable)
        let groupedTransactionsCodable = CodableTransactionsGroup(startDate: 1234567, endDate: 1234568, amount: balanceCodable, transactions: [transactionCodable])
        let groupedTransactionsPageCodable = CodableSuccessTransactionsGroupedSearchingResponse.GroupedTransactionsPage(count: 1, next: nil, transactions: [groupedTransactionsCodable])
        let responseCodable = CodableSuccessTransactionsGroupedSearchingResponse(result: true, data: groupedTransactionsPageCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = try GroupedTransactionsPageData(codable: groupedTransactionsPageCodable)
            userAPI.getTransactions(token: token).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating GroupedTransactionsPageData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `getTransactions(token:filter:phoneNumberFormatter:localContacts:)` method.
     */
    func testGettingTransactionsFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.getTransactions(token: token).done {
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
     Test succeed performance of `getKYCPersonalInfo(token:)` method.
     */
    func testGettingKYCPersonalInfoSucceed() {
        // given
        // Construct response codable object
        let addressCodable = CodableKYCPersonalInfo.CodableInfoProperties.CodableAddress(city: "test", region: "test", street: "test", house: "test", postalCode: 123)
        let personalInfoPropertiesCodable = CodableKYCPersonalInfo.CodableInfoProperties(email: "test", firstName: "test", lastName: "test", birthDate: 12345, sex: GenderType.male.rawValue, country: "test", address: addressCodable)
        let kycPersonalInfoCodable = CodableKYCPersonalInfo(status: KYCStatus.verified.rawValue, personalData: personalInfoPropertiesCodable)
        let responseCodable = CodableSuccessKYCPersonalInfoResponse(result: true, data: kycPersonalInfoCodable)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        do {
            let expectedResponse = try KYCPersonalInfo(codable: kycPersonalInfoCodable)
            userAPI.getKYCPersonalInfo(token: token).done {
                response in
                // then
                XCTAssertEqual(response, expectedResponse)
            }.catch {
                _ in
                // then
                XCTFail("Response should be succeed, not failure")
            }
        } catch let error {
            XCTFail("Fail on creating GroupedTransactionsPageData from codable object: \(error.localizedDescription)")
        }
    }

    /**
     Test failed performance of `getKYCPersonalInfo(token:)` method.
     */
    func testGettingKYCPersonalInfoFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.getKYCPersonalInfo(token: token).done {
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
     Test succeed performance of `sendKYCPersonalInfo(token:email:firstName:lastName:birthDate:gender:country:city:region:street:house:postalCode:)` method.
     */
    func testSendingKYCPersonalInfoSucceed() {
        // given
        // Construct response codable object
        let responseCodable = CodableSuccessEmptyResponse(result: true)

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let email = "email"
        let firstName = "firstName"
        let lastName = "lastName"
        let birthDate = Date()
        let gender = GenderType.male
        let country = "country"
        let city = "city"
        let region = "region"
        let street = "street"
        let house = "house"
        let postalCode = 123

        //when
        userAPI.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, gender: gender, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode).done {
            response in
            // then
            XCTAssertTrue(true)
        }.catch {
            _ in
            // then
            XCTFail("Response should be succeed, not failure")
        }
    }

    /**
     Test failed performance of `sendKYCPersonalInfo(token:email:firstName:lastName:birthDate:gender:country:city:region:street:house:postalCode:)` method.
     */
    func testSendingKYCPersonalInfoFailure() {
        // given
        // Construct response codable object
        let error = "Test message"
        let codableError = CodableFailure.Error.init(name: nil, input: nil, message: error)
        let responseCodable = CodableFailure(result: false, message: nil, errors: [codableError])

        // Build provider with mocking response data
        let provider = buildProviderWith(response: responseCodable)

        // Create auth service with mocked provider
        let userAPI = UserAPI(provider: provider)

        let token = "token"
        let email = "email"
        let firstName = "firstName"
        let lastName = "lastName"
        let birthDate = Date()
        let gender = GenderType.male
        let country = "country"
        let city = "city"
        let region = "region"
        let street = "street"
        let house = "house"
        let postalCode = 123

        //when
        let expectedResponse: CodableFailure.Error? = codableError
        userAPI.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, gender: gender, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode).done {
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
