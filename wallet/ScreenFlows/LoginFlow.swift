//
//  LoginFlow.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

final class LoginFlow: ScreenFlow {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func begin() {
        self.navigationController?.pushViewController(enterPhoneNumberScreen, animated: true)
    }

    lazy var enterPhoneNumberScreen: EnterPhoneNumberViewController = {
        let vc = EnterPhoneNumberViewController()
        let onContinue: (String) -> Void = {
            [weak self]
            phone in

            guard let strongSelf = self else {
                return
            }

            let target = strongSelf.enterLoginPasswordScreen
            target.prepare(phone: phone)

            strongSelf.navigationController?.pushViewController(target, animated: true)
        }

        vc.onContinue = onContinue
        return vc
    }()

    lazy var enterLoginPasswordScreen: EnterLoginPasswordViewController = {
        let vc = EnterLoginPasswordViewController()
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
        return vc
    }()

    lazy var userScreen: UserViewController = {
        let vc = UserViewController()
        return vc
    }()
}
