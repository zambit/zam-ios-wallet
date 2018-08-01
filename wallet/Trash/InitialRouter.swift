//
//  InitialRouter.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct InitialRouter: Router {

    enum Point {
        case loginPinCode
        case onboarding
    }

    func route(to point: InitialRouter.Point, from context: UIViewController, parameters: [Any]?) {

    }

}
