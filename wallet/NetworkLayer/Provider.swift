//
//  Provider.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import PromiseKit

protocol Provider {

    associatedtype ProviderRequest: Request

    associatedtype ProviderEnvironment: Environment

    init(environment: ProviderEnvironment, dispatcher: Dispatcher)

    func execute(_ request: ProviderRequest) -> Promise<Response>
}
