//
//  Provider.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

/**
 Protocol defines object, uniting corresponding Request and Environment objects for easily executing requests in right environment.
 */
struct Provider {

    private let environment: Environment
    private let dispatcher: Dispatcher

    init(environment: Environment, dispatcher: Dispatcher) {
        self.environment = environment
        self.dispatcher = dispatcher
    }

    func execute(_ request: Request) -> Promise<Response> {
        return dispatcher.dispatch(request: request, with: environment)
    }

    func cancelAllTasks() {
        dispatcher.cancelAllTasks()
    }
}
