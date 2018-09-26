//
//  Response+Extensions.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

@testable import wallet

extension Response: Equatable {

    public static func == (lhs: Response, rhs: Response) -> Bool {
        switch (lhs, rhs) {
        case (let .data(ldata), let .data(rdata)):
            return ldata == rdata

        case (let .error(lerror), let .error(rerror)):
            return lerror.localizedDescription == rerror.localizedDescription

        default:
            return false
        }
    }
}
