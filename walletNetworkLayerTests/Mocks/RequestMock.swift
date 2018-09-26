//
//  RequestMock.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

@testable import wallet

struct RequestMock: Request {

    var path: String {
        return "path"
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: RequestParams? {
        return nil
    }

    var headers: [String : Any]? {
        return nil
    }
}
