//
//  StubsLoader.swift
//  walletNetworkLayerTests
//
//  Created by Alexander Ponomarev on 28/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct StubsLoader {

    static let bundle = Bundle(identifier: "zamzam.wallet.walletNetworkLayerTests")

    static func loadData(from file: String) throws -> Data {
        guard let path = bundle?.path(forResource: "Files/\(file)", ofType: "json") else {
            throw StubsLoaderError.particularStubNotExists
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}

enum StubsLoaderError: Error {
    case particularStubNotExists
}
