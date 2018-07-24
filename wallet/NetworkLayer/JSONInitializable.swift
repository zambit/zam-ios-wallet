//
//  JSONInitializable.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONInitializable {
    
    init(with json: JSON) throws
}
