//
//  KYCPersonalInfoViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 07/09/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class KYCPersonalInfoViewController: FlowViewController, WalletNavigable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView?

    private var forms: [(String, [String])] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //migratingNavigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        forms = [
            ("Personal info", ["Email", "First name", "Last name", "Date of birth", "Gender"]),
            ("Personal info", ["Country", "City", "State / Region", "Street", "House number", "Postal Code"])]

        hideKeyboardOnTap()

        self.tableView?.register(TextFieldCell.self , forCellReuseIdentifier: "TextFieldCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = .white
        self.tableView?.separatorStyle = .none
        self.tableView?.allowsSelection = false

        self.view.applyDefaultGradientHorizontally()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return forms.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms[section].1.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear

        let headerLabel = UILabel()
        headerLabel.font = UIFont.walletFont(ofSize: 30.0, weight: .bold)
        headerLabel.textColor = .darkIndigo
        headerLabel.text = forms[section].0
        headerLabel.sizeToFit()

        header.addSubview(headerLabel)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 16.0).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: header.rightAnchor, constant: 16.0).isActive = true
        headerLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 4.0).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 4.0).isActive = true

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)

        guard let cell = _cell as? TextFieldCell else {
            fatalError()
        }

        let data = forms[indexPath.section].1[indexPath.row]
        cell.textField.placeholder = data

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}
