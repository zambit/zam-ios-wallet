//
//  CustomBehavioral.swift
//  wallet
//
//  Created by Alexander Ponomarev on 04/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

public protocol CustomBehavioral {
    associatedtype TargetType: AnyObject

    var custom: BehaviorExtension<TargetType> { get set }
}

public extension CustomBehavioral where Self: AnyObject {
    public var custom: BehaviorExtension<Self> {
        get { return BehaviorExtension(self) }
        set { }
    }
}

public class BehaviorExtension<Base: AnyObject> {
    unowned var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

extension UIView: CustomBehavioral {}

extension UIViewController: CustomBehavioral {}
