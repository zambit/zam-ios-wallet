//
//  OnboardingRouter.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

struct OnboardingRouter: Router {

    enum Point {
        case enterPhoneNumber(next: Extra)

        enum Extra {
            case loginFirstEnter
            case loginSecondEnter
            case registration
        }
    }

    func route(to point: Point, from context: UIViewController, parameters: [Any]? = nil) {

        switch point {
        case .enterPhoneNumber(next: let next):
            return
        }
    }

}
