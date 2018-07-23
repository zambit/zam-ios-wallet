//
//  RegistrationCoordinator.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class RegistrationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    weak var navigationController: UINavigationController?

    func begin() {
        let vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneNumber", storyboardName: "EnterPhoneNumber")
        navigationController?.pushViewController(vc, animated: true)
    }
}
