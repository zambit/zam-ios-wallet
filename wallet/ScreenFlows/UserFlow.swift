//
//  UserFlow.swift
//  wallet
//
//  Created by  me on 02/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class UserFlow: ScreenFlow {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.pushViewController(userScreen, animated: true)
    }

    private var userScreen: UserViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "UserViewController", storyboardName: "Main")

        guard let vc = _vc as? UserViewController else {
            fatalError()
        }

        vc.userManager = WalletUserDefaultsManager()
        return vc
    }

}
