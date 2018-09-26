//
//  CodableFailure.Type+TestsExtensions.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

@testable import wallet

extension CodableFailure.Error: Equatable {

    public static func == (lhs: CodableFailure.Error, rhs: CodableFailure.Error) -> Bool {
        return lhs.name == rhs.name && lhs.input == rhs.input && lhs.message == rhs.message
    }

}
