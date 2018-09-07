//
//  KycFlow.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class KycFlow: ScreenFlow {

    unowned var migratingNavigationController: WalletNavigationController

    init(migratingNavigationController: WalletNavigationController) {
        self.migratingNavigationController = migratingNavigationController
    }

    func begin() {
        self.migratingNavigationController.custom.push(viewController: mainKYCScreen)
    }

    private var mainKYCScreen: KYCMainScreenViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "KYCMainScreenViewController", storyboardName: "Main")

        guard let vc = _vc as? KYCMainScreenViewController else {
            fatalError()
        }

        vc.title = "Identify verification"
        vc.flow = self
        return vc
    }

}
