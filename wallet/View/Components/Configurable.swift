//
//  ItemConfigurable.swift
//  wallet
//
//  Created by Alexander Ponomarev on 08/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

protocol Configurable {

    associatedtype ConfiguratingType

    func configure(with data: ConfiguratingType)
}
