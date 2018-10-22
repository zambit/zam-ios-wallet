//
//  EnvironmentMock.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

@testable import wallet

struct EnvironmentMock: Environment {

    var host: String {
        return "testing"
    }

    var parameters: RequestParams? {
        return nil
    }

    var headers: [String : Any] {
        return [:]
    }
}
