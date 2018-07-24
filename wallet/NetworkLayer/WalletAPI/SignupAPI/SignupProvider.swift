//
//  SignupProvider.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

struct SignupProvider: Provider {

    private let environment: WalletEnvironment

    private let dispatcher: Dispatcher
    
    init(environment: WalletEnvironment, dispatcher: Dispatcher) {
        self.environment = environment
        self.dispatcher = dispatcher
    }

    func execute(_ request: SignupRequest) -> Promise<Response> {
        return dispatcher.dispatch(request: request, with: environment)
    }
}
