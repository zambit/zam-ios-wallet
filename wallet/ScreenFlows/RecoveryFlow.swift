//
//  RecoveryFlow.swift
//  wallet
//
//  Created by  me on 01/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class RecoveryFlow: ScreenFlow {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(enterPhoneNumberScreen, animated: true)
    }

    private var enterPhoneNumberScreen: EnterPhoneNumberViewController {
        let _vc = ControllerHelper.instantiateViewController(identifier: "EnterPhoneNumberViewController", storyboardName: "Recovery")

        guard let vc = _vc as? EnterPhoneNumberViewController else {
            fatalError()
        }

        let onContinue: (String) -> Void = {
            [weak self]
            authToken in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.userScreen
            target.prepare(authToken: authToken)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }

        vc.onContinue = onContinue
        vc.recoveryAPI = RecoveryAPI(provider: RecoveryProvider(environment: WalletEnvironment(), dispatcher: HTTPDispatcher()))
        vc.flow = self
        return vc
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
