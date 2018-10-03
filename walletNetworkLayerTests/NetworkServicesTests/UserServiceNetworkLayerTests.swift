//
//  UserServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 27/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

enum UserServiceNetworkLayerStubs {
    case getUserInfo
    case getWallets
    case getWalletInfo
    case sendTransaction
    case getTransactions
    case getKYCPersonalInfo
    case sendKYCPersonalInfo
    case failure

    var resourceName: String {
        switch self {
        case .getUserInfo:
            return "user_get_user_info"
        case .getWallets:
            return "user_get_wallets"
        case .getWalletInfo:
            return "user_get_wallet_info"
        case .sendTransaction:
            return "user_send_transaction"
        case .getTransactions:
            return "user_get_transactions"
        case .getKYCPersonalInfo:
            return "user_get_kyc_personal_info"
        case .sendKYCPersonalInfo:
            return "successful_empty_response"
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

            let codableError = CodableWalletFailure.Error(name: name, input: input, message: error)
            let responseError = WalletResponseError.serverFailureResponse(errors: [codableError])
            return responseError
        default:
            return nil
        }
    }
}

class UserServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `getUserInfo(token: coin:)` method.
     */
    func testGettingUserInfoSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.getUserInfo
        let preparedBalances = [BalanceData(coin: .btc, usd: 0.0, original: 0.0)]
        let comparingObject = UserData(id: "", phone: "+79111111111", status: "active", registeredAt: 1538143682, balances: preparedBalances)

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting user info")

            userAPI.getUserInfo(token: token, coin: nil).done {
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
     Test failed performance of `getUserInfo(token:coin:)` method.
     */
    func testGettingUserInfoFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting user info")

            userAPI.getUserInfo(token: token, coin: nil).done {
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

                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `getWallets(token:coin:id:page:count:)` method.
     */
    func testGettingWalletsSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.getWallets
        let preparedBalance = BalanceData(coin: .btc, usd: 0.0, original: 0.0)
        let comparingObject = [WalletData(id: "128", name: "BTC wallet", coin: .btc, balance: preparedBalance, address: "2N9tSiDXRZbP7xzfvC8fruveZXjrRqerXeD")]

        do {
            // Build provider with mocking response data
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting wallets")

            userAPI.getWallets(token: token).done {
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
     Test failed performance of `getWallets(token:coin:id:page:count:)` method.
     */
    func testGettingWalletsFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting wallets")

            userAPI.getWallets(token: token).done {
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

                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `getWalletInfo(token:walletId:)` method.
     */
    func testGettingWalletInfoSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.getWalletInfo
        let preparedBalance = BalanceData(coin: .bch, usd: 0.0, original: 0.0)
        let comparingObject = WalletData(id: "129", name: "BCH wallet", coin: .bch, balance: preparedBalance, address: "qzvrz7wxxk8flh6fu3fdlqywwu3nypcqys5lckpxff")

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let walletId = "129"

            // when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting wallet info")

            userAPI.getWalletInfo(token: token, walletId: walletId).done {
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
     Test failed performance of `getWalletInfo(token:walletId:)` method.
     */
    func testGettingWalletInfoFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let walletId = "129"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting wallet info")

            userAPI.getWalletInfo(token: token, walletId: walletId).done {
                response in
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `sendTransaction(token:walletId:recipient:amount:)` method.
     */
    func testSendingTransactionSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.sendTransaction
        let preparedBalance = BalanceData(coin: .btc, usd: 6.61251, original: 0.001)
        let comparingObject = TransactionData(id: "409", direction: .outgoing, status: .pending, coin: .btc, participantType: .recipient, participant: "+79111511111", amount: preparedBalance)

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let walletId = "0"
            let amount: Decimal = 0.001
            let recipient = "+79111511111"

            // when
            let expectation = XCTestExpectation(description: "Test successful responsing for sending transaction")

            userAPI.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount).done {
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
     Test failed performance of `sendTransaction(token:walletId:recipient:amount:)` method.
     */
    func testSendingTransactionFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with mocking response data
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let walletId = "0"
            let amount: Decimal = 0.001
            let recipient = "+79111511111"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for sending transaction")

            userAPI.sendTransaction(token: token, walletId: walletId, recipient: recipient, amount: amount).done {
                response in
                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? WalletResponseError else {
                    XCTFail("Wrong fail response type")
                    return
                }

                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `getTransactions(token:filter:phoneNumberFormatter:localContacts:)` method.
     */
    func tesGettingTransactionsSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.getTransactions
        let preparedBalance = BalanceData(coin: .btc, usd: 257.55873, original: 0.039)
        let preparedTransaction = TransactionData(id: "408", direction: .outgoing, status: .success, coin: .btc, participantType: .recipient, participant: "+79111511111", amount: preparedBalance)
        let preparedDateInterval = DateInterval(startUnixTimestamp: 1537995600, endUnixTimestamp: 1538082000)
        let preparedTransactionsGroup = TransactionsGroupData(dateInterval: preparedDateInterval, amount: preparedBalance, transactions: [preparedTransaction])
        let comparingObject = GroupedTransactionsPageData(next: "382", transactions: [preparedTransactionsGroup])

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting transactions")

            userAPI.getTransactions(token: token).done {
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
     Test failed performance of `getTransactions(token:filter:phoneNumberFormatter:localContacts:)` method.
     */
    func testGettingTransactionsFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting transactions")

            userAPI.getTransactions(token: token).done {
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

                XCTAssertEqual(response, stub.failureObject)

                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
        } catch let error {
            XCTFail("Wrong json stub format: \(error)")
        }
    }

    /**
     Test succeed performance of `getKYCPersonalInfo(token:)` method.
     */
    func testGettingKYCPersonalInfoSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.getKYCPersonalInfo
        let preparedKYCData = KYCPersonalInfoData(email: "test@mail.ru", firstName: "Name", lastName: "Surname", birthDate: Date(unixTimestamp: 717552000.0), gender: .male, country: "Test", city: "Test", region: "Test Region", street: "test street", house: "14", postalCode: 644122)
        let comparingObject = KYCPersonalInfo(status: .pending, data: preparedKYCData)

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting kyc personal info")

            userAPI.getKYCPersonalInfo(token: token).done {
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
     Test failed performance of `getKYCPersonalInfo(token:)` method.
     */
    func testGettingKYCPersonalInfoFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting kyc personal info")

            userAPI.getKYCPersonalInfo(token: token).done {
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
     Test succeed performance of `sendKYCPersonalInfo(token:email:firstName:lastName:birthDate:gender:country:city:region:street:house:postalCode:)` method.
     */
    func testSendingKYCPersonalInfoSucceed() {
        // given
        let stub = UserServiceNetworkLayerStubs.sendKYCPersonalInfo

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let email = "test@mail.ru"
            let firstName = "Name"
            let lastName = "Surname"
            let birthDate = Date()
            let gender = GenderType.male
            let country = "Test"
            let city = "Test"
            let region = "Test Region"
            let street = "test street"
            let house = "14"
            let postalCode = 123

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for sending kyc personal info")

            userAPI.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, gender: gender, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode).done {
                response in
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
     Test failed performance of `sendKYCPersonalInfo(token:email:firstName:lastName:birthDate:gender:country:city:region:street:house:postalCode:)` method.
     */
    func testSendingKYCPersonalInfoFailure() {
        // given
        let stub = UserServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let userAPI = UserAPI(provider: provider)

            let token = "token"
            let email = "test@mail.ru"
            let firstName = "Name"
            let lastName = "Surname"
            let birthDate = Date()
            let gender = GenderType.male
            let country = "Test"
            let city = "Test"
            let region = "Test Region"
            let street = "test street"
            let house = "14"
            let postalCode = 123

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for sending kyc personal info")

            userAPI.sendKYCPersonalInfo(token: token, email: email, firstName: firstName, lastName: lastName, birthDate: birthDate, gender: gender, country: country, city: city, region: region, street: street, house: house, postalCode: postalCode).done {
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
