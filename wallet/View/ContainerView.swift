//
//  ContainerView.swift
//  wallet
//
//  Created by  me on 09/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class ContainerView: UIView {

    private weak var owner: UIViewController?

    weak var embededViewController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(viewController: UIViewController, owner: UIViewController) {
        self.owner = owner
        self.embededViewController = viewController

        owner.addChild(viewController)

        addSubview(viewController.view)

        viewController.view.frame = bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        viewController.didMove(toParent: owner)
    }

    deinit {
        embededViewController?.view.removeFromSuperview()
        embededViewController?.removeFromParent()
    }
}
