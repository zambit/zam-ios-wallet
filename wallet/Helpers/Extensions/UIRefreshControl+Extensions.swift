//
//  UIRefreshControl+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 30/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIRefreshControl {

    func beginRefreshing(in tableView: UITableView) {
        beginRefreshing()

        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
