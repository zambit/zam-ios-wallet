//
//  Environment.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

protocol Environment {

    var host: String { get }

    var headers: [String: Any] { get }
}
