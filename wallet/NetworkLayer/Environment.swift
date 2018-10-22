//
//  Environment.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

/**
 Protocol defines general API object that provides host path and default headers.
 */
protocol Environment {

    var host: String { get }

    var parameters: RequestParams? { get }

    var headers: [String: Any] { get }
}
