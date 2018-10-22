//
//  WalletDetailsListsTableViewCell.swift
//  wallet
//
//  Created by Alexander Ponomarev on 11/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class WalletDetailsListsTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    private var titleLabel: UILabel!
    private var tableView: UITableView!

    private var detailsData: [DetailTableViewCellData] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
        setupSubviews()
    }

    private func setupStyle() {
        self.backgroundColor = .white
    }

    private func setupSubviews() {
        self.hero.isEnabled = true
        self.hero.modifiers = [.fade]

        let titleLabel = UILabel()
        titleLabel.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel.textColor = .darkIndigo
        titleLabel.textAlignment = .left
        titleLabel.text = "Information"

        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 17.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -17.0).isActive = true

        self.titleLabel = titleLabel


        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self

        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        self.tableView = tableView
    }

    func update(marketCap: String, volume: String, supply: String) {
        let marketCapData = DetailTableViewCellData(title: "Market Cap", detailValue: marketCap)
        let volumeData = DetailTableViewCellData(title: "24H Volume", detailValue: volume)
        let supplyData = DetailTableViewCellData(title: "Supply", detailValue: supply)

        detailsData = [marketCapData, volumeData, supplyData]
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)

        guard let cell = _cell as? DetailTableViewCell else {
            fatalError()
        }

        let data = detailsData[indexPath.row]
        cell.configure(with: data)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
}
