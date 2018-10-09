//
//  KeychainConfiguration.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

protocol KeychainConfiguration {

    var serviceName: String { get }
    
    var accessGroup: String? { get }

}
