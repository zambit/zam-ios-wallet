//
//  CoinFullData.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct CoinPrice: Equatable {

    let coin: CoinType

    let fiat: FiatType

    let price: Decimal

    let marketCap: Decimal

    let volumeDay: Decimal
    let volume24h: Decimal

    let changePct24h: Decimal
    let change24h: Decimal

    let openDay: Decimal
    let highDay: Decimal
    let lowDay: Decimal

    let open24h: Decimal
    let high24h: Decimal
    let low24h: Decimal

    let supply: Decimal

    init(coin: CoinType, fiat: FiatType, price: Decimal, marketCap: Decimal, volumeDay: Decimal, volume24h: Decimal, changePct24h: Decimal, change24h: Decimal, openDay: Decimal, highDay: Decimal, lowDay: Decimal, open24h: Decimal, high24h: Decimal, low24h: Decimal, supply: Decimal) {
        self.coin = coin
        self.fiat = fiat
        self.price = price
        self.marketCap = marketCap
        self.volumeDay = volumeDay
        self.volume24h = volume24h
        self.changePct24h = changePct24h
        self.change24h = change24h
        self.openDay = openDay
        self.highDay = highDay
        self.lowDay = lowDay
        self.open24h = open24h
        self.high24h = high24h
        self.low24h = low24h
        self.supply = supply
    }

    init(codable: CodableCoinData) throws {
        guard let coin = CoinType(rawValue: codable.coin.lowercased()) else {
            throw CoinPriceError.coinTypeInputFormatError
        }
        self.coin = coin

        guard let fiat = FiatType(rawValue: codable.fiat.lowercased()) else {
            throw CoinPriceError.fiatTypeInputFormatError
        }
        self.fiat = fiat

        self.price = codable.price

        self.marketCap = codable.marketCap

        self.volumeDay = codable.volumeDay
        self.volume24h = codable.volume24h

        self.changePct24h = codable.changePct24h
        self.change24h = codable.change24h

        self.openDay = codable.openDay
        self.highDay = codable.highDay
        self.lowDay = codable.lowDay

        self.open24h = codable.open24h
        self.high24h = codable.high24h
        self.low24h = codable.low24h

        self.supply = codable.supply
    }

    enum Properties {
        case price
        case marketCap
        case volumeDay
        case volume24h
        case changePct24h
        case change24h
        case openDay
        case highDay
        case lowDay
        case open24h
        case high24h
        case low24h
        case supply
    }

    func description(property: Properties) -> String {
        do {
            switch property {
            case .price:
                let prefix = fiat.symbol
                let currency = try price.format(to: .smart)
                return "\(prefix)\(currency)"
            case .marketCap:
                let prefix = fiat.symbol
                let postfix = fiat.short
                let currency = try marketCap.format(to: .largeDecimals)
                return "\(prefix)\(currency) \(postfix)"
            case .volumeDay:
                let postfix = coin.short
                let currency = try volumeDay.format(to: .largeDecimals)
                return "\(currency) \(postfix)"
            case .volume24h:
                let postfix = coin.short
                let currency = try volume24h.format(to: .largeDecimals)
                return "\(currency) \(postfix)"
            case .changePct24h:
                let percents = try changePct24h.format(to: .short)
                return "\(percents)%"
            case .change24h:
                let prefix = fiat.symbol
                let currency = try change24h.format(to: .short)
                return "\(prefix)\(currency)"
            case .openDay:
                let prefix = fiat.symbol
                let currency = try openDay.format(to: .short)
                return "\(prefix)\(currency)"
            case .highDay:
                let prefix = fiat.symbol
                let currency = try highDay.format(to: .short)
                return "\(prefix)\(currency)"
            case .lowDay:
                let prefix = fiat.symbol
                let currency = try lowDay.format(to: .short)
                return "\(prefix)\(currency)"
            case .open24h:
                let prefix = fiat.symbol
                let currency = try open24h.format(to: .short)
                return "\(prefix)\(currency)"
            case .high24h:
                let prefix = fiat.symbol
                let currency = try high24h.format(to: .short)
                return "\(prefix)\(currency)"
            case .low24h:
                let prefix = fiat.symbol
                let currency = try low24h.format(to: .short)
                return "\(prefix)\(currency)"
            case .supply:
                let postfix = coin.short
                let currency = try supply.format(to: .largeDecimals)
                return "\(currency) \(postfix)"
            }

        } catch {
            return ""
        }
    }
}

enum CoinPriceError: Error {

    case coinTypeInputFormatError
    case fiatTypeInputFormatError
}
