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

    var userManager: UserDefaultsManager?
    var userAPI: UserAPI?

    var onSend: ((KYCStatus) -> Void)?

    @IBOutlet var tableView: UITableView?
    @IBOutlet var safeAreaView: UIView?

    private weak var sendButton: StageButton?
    private var currentIndexPath: IndexPath?

    private var forms: [(String, [TextFieldCellData])] = []
    private var progress: KYCPersonalInfoProgress = KYCPersonalInfoProgress()

    private var personalInfoData: KYCPersonalInfoData?
    private var approvingState: KYCStatus = .unloaded

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        forms = [
            ("Personal info",
             [TextFieldCellData(placeholder: "Email",
                                keyboardType: .emailAddress,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.email = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "First name",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.firstName = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "Last name",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.lastName = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "Date of birth",
                                keyboardType: nil,
                                action: .tap({ [weak self] textField in

                                    self?.dismissKeyboard()

                                    let alert = UIAlertController(style: .actionSheet, title: "Select date")
                                    alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) {
                                        date in

                                        textField.text = Date.walletLongString(from: date)
                                        self?.progress.birthDate = date
                                    }
                                    alert.addAction(title: "Done", style: .cancel)
                                    alert.show() }),
                                beginEditingAction: nil
                ),
              TextFieldCellData(placeholder: "Gender",
                                keyboardType: nil,
                                action: .tap({ [weak self] textField in

                                    self?.dismissKeyboard()

                                    let alert = UIAlertController(style: .actionSheet, title: "Select gender")
                                    alert.addAction(title: "Male", style: .default) { _ in
                                        textField.text = "Male"
                                        self?.progress.gender = .male
                                    }
                                    alert.addAction(title: "Female", style: .default) { _ in
                                        textField.text = "Female"
                                        self?.progress.gender = .female
                                    }
                                    alert.addAction(title: "Done", style: .cancel)
                                    alert.show() }),
                                beginEditingAction: nil
                )]),
            ("Personal info",
             [TextFieldCellData(placeholder: "Country",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.country = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "City",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.city = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "State / Region",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.region = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "Street",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.street = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "House number",
                                keyboardType: .default,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.house = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                ),
              TextFieldCellData(placeholder: "Postal code",
                                keyboardType: .numberPad,
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.postalCode = textField.text }),
                                beginEditingAction: { [weak self]
                                    cell in

                                    self?.checkCellPosition(cell)}
                )])
        ]
        hideKeyboardOnTap()


        self.tableView?.register(TextFieldCell.self , forCellReuseIdentifier: "TextFieldCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = .white
        self.tableView?.separatorStyle = .none
        self.tableView?.allowsSelection = false

        self.view.applyDefaultGradientHorizontally()
    }

    func prepare(data: KYCPersonalInfo) {
        self.personalInfoData = data.data
        self.approvingState = data.status

        self.progress = KYCPersonalInfoProgress(data: data.data)

        switch data.status {
        case .unloaded:
            sendButton?.custom.changeState(to: 0)
        case .pending:
            sendButton?.custom.changeState(to: 1)
        case .verified:
            sendButton?.custom.changeState(to: 2)
        }
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
        let cell = TextFieldCell()
        cell.configure(with: forms[indexPath.section].1[indexPath.row])
        cell.set(text: progress.getTextFor(indexPath: indexPath) ?? "")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == forms.count - 1, personalInfoData == nil else {
            return nil
        }

        let footer = UIView()
        footer.backgroundColor = .clear

        let sendButton = StageButton(type: .custom)
        sendButton.custom.setup(type: .small, stages: [
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue),
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icTime"), imageTintColor: .white),
            StageDescription(description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue, image: #imageLiteral(resourceName: "icCheck"), imageTintColor: .white)])

        footer.addSubview(sendButton)

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 230.0).isActive = true

        self.sendButton = sendButton

        sendButton.custom.setEnabled(progress.isCompleted)
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpInsideEvent(_:)), for: .touchUpInside)

        progress.completionCallback = {
            progress in

            sendButton.custom.setEnabled(true)
        }

        progress.incompletionCallback = {
            sendButton.custom.setEnabled(false)
        }

        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == forms.count - 1, personalInfoData == nil else {
            return 0.0
        }

        return 76.0
    }

    private func checkCellPosition(_ cell: TextFieldCell) {
        guard let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window else {
            return
        }

        let position = cell.convert(cell.bounds.origin, to: window)

        if position.y + cell.bounds.height + 15 > window.bounds.height - 350 {
            currentIndexPath = tableView?.indexPath(for: cell)
        } else {
            currentIndexPath = nil
        }
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: Any) {
        guard let token = userManager?.getToken(), let personalData = progress.data else {
            return
        }

        sendButton?.custom.beginLoading()

        userAPI?.sendKYCPersonalInfo(token: token, personalData: personalData).done {
            [weak self] in

            self?.dismissKeyboard()
            performWithDelay {
                self?.sendButton?.custom.endLoading()
                self?.onSend?(.pending)
            }
        }.catch {
            [weak self]
            error in

            print(error)
            self?.sendButton?.custom.endLoading()
        }
    }

    private var contentOffsetBeforeKeeyboard: CGPoint?

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let tableView = tableView,
            let safeArea = safeAreaView,
            let indexPath = currentIndexPath,
            let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        guard let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }

        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)

        contentOffsetBeforeKeeyboard = tableView.contentOffset

        let cellPosition = cell.convert(cell.bounds.origin, to: safeArea)
        let bottomSpace = tableView.height - cellPosition.y - cell.height - 15.0

        tableView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y + keyboardFrame.size.height - bottomSpace)
    }

    @objc
    private func keyboardWillHide(notification:NSNotification) {
        guard let contentOffset = contentOffsetBeforeKeeyboard else {
            return
        }

        tableView?.contentOffset = contentOffset
    }
}