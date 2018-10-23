//
//  HistoryServiceNetworkLayerTests.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 03/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import XCTest
@testable import wallet

enum HistoryServiceNetworkLayerStubs {
    case getDailyData
    case getHourlyData
    case getMinuteData
    case failure

    var resourceName: String {
        switch self {
        case .getDailyData:
            return "historical_data"
        case .getHourlyData:
            return "historical_data"
        case .getMinuteData:
            return "historical_data"
        case .failure:
            return "cryptocompare_fail_response"
        }
    }

    var failureObject: CryptocompareResponseError? {
        switch self {
        case .failure:
            let message = "failure message"

            let responseError = CryptocompareResponseError.serverFailureResponse(message: message)
            return responseError
        default:
            return nil
        }
    }
}

class HistoryServiceNetworkLayerTests: ServiceNetworkLayerTests {

    /**
     Test succeed performance of `getHistoricalDailyData(for: count:)` method.
     */
    func testGettingDailyDataCodeSucceed() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.getDailyData
        let preparedHistoricalObject = CodableCoinHistoricalData(time: 1535846400, close: 7301.26, high: 7384.38, low: 7144.71, open: 7203.46, volumeFrom: 61424.38, volumeTo: 447453370.83)
        let preparedDailyData = CoinHistoricalPrice(coin: .btc, fiat: .usd, codable: preparedHistoricalObject)
        let comparingObject: [CoinHistoricalPrice] = [preparedDailyData]

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting daily data")

            historyAPI.getHistoricalDailyPrice(for: coin, count: days).done {
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
     Test failed performance of `getHistoricalDailyPrice(for: count:)` method.
     */
    func testGettingDailyDataCodeFailure() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting daily data")

            historyAPI.getHistoricalDailyPrice(for: coin, count: days).done {
                _ in

                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? CryptocompareResponseError else {
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
     Test succeed performance of `getHistoricalHourlyData(for: count:)` method.
     */
    func testGettingHourlyDataCodeSucceed() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.getHourlyData
        let preparedHistoricalObject = CodableCoinHistoricalData(time: 1535846400, close: 7301.26, high: 7384.38, low: 7144.71, open: 7203.46, volumeFrom: 61424.38, volumeTo: 447453370.83)
        let preparedDailyData = CoinHistoricalPrice(coin: .btc, fiat: .usd, codable: preparedHistoricalObject)
        let comparingObject: [CoinHistoricalPrice] = [preparedDailyData]

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting daily data")

            historyAPI.getHistoricalHourlyPrice(for: coin, count: days).done {
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
     Test failed performance of `getHistoricalHourlyPrice(for: count:)` method.
     */
    func testGettingHourlyDataCodeFailure() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting daily data")

            historyAPI.getHistoricalHourlyPrice(for: coin, count: days).done {
                _ in

                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? CryptocompareResponseError else {
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
     Test succeed performance of `getHistoricalMinuteData(for: count:)` method.
     */
    func testGettingMinuteDataCodeSucceed() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.getMinuteData
        let preparedHistoricalObject = CodableCoinHistoricalData(time: 1535846400, close: 7301.26, high: 7384.38, low: 7144.71, open: 7203.46, volumeFrom: 61424.38, volumeTo: 447453370.83)
        let preparedDailyData = CoinHistoricalPrice(coin: .btc, fiat: .usd, codable: preparedHistoricalObject)
        let comparingObject: [CoinHistoricalPrice] = [preparedDailyData]

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test successful responsing for getting daily data")

            historyAPI.getHistoricalMinutePrice(for: coin, count: days).done {
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
     Test failed performance of `getHistoricalMinutePrice(for: count:)` method.
     */
    func testGettingMinuteDataCodeFailure() {
        // given
        let stub = HistoryServiceNetworkLayerStubs.failure

        do {
            // Build provider with response test json file
            let provider = try buildProviderWith(resourceName: stub.resourceName)

            // Create auth service with mocked provider
            let historyAPI = HistoryAPI(provider: provider)

            let coin = CoinType.btc
            let days = 30

            //when
            let expectation = XCTestExpectation(description: "Test failure responsing for getting daily data")

            historyAPI.getHistoricalMinutePrice(for: coin, count: days).done {
                _ in

                // then
                XCTFail("Response should be a failure, not success")

                expectation.fulfill()
            }.catch {
                e in

                guard let response = e as? CryptocompareResponseError else {
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
}
