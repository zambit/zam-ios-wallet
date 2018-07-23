//
//  Provider.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

protocol Provider {

    associatedtype ProviderRequest: Request

    associatedtype ProviderEnvironment: Environment

    init(environment: ProviderEnvironment, dispatcher: Dispatcher)

    func execute(_ request: ProviderRequest) -> Response
}
