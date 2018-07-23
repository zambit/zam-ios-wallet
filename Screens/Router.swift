//
//  Router.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol Router {

    associatedtype Point

    func route(to point: Point, from context: UIViewController, parameters: [Any]?)
}
