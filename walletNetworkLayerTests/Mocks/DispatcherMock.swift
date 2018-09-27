//
//  DispatcherMock.swift
//  walletNetworkLayerTests
//
//  Created by Александр Пономарев on 26/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import PromiseKit
@testable import wallet

struct DispatcherMock: Dispatcher {

    var response: Response?
    var error: Error?

    func dispatch(request: Request, with environment: Environment) -> Promise<Response> {
        return Promise { seal in
            seal.resolve(response, error)
        }
    }

    func cancelAllTasks() {
        //...
    }
}
