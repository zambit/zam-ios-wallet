//
//  NetworkService.swift
//  wallet
//
//  Created by  me on 24/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

protocol NetworkService {

    associatedtype APIProvider: Provider

    init(provider: APIProvider)
}
