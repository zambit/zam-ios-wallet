//
//  Dispatcher.swift
//  wallet
//
//  Created by  me on 23/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import PromiseKit

/**
 Protocol defines object, implementing sending requests and handling responses on basic level.
 Use to organize work with network through URLSession or Alamofire using one Dispatcher template.
 */
protocol Dispatcher {

    func dispatch(request: Request, with environment: Environment) -> Promise<Response>
}
