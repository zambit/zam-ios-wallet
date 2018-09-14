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
protocol Provider {
    
    associatedtype ProviderRequest: Request

    associatedtype ProviderEnvironment: Environment

    init(environment: ProviderEnvironment, dispatcher: Dispatcher)

    func execute(_ request: ProviderRequest) -> Promise<Response>
}
