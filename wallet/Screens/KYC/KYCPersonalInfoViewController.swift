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

    var onSend: ((KYCApprovingState) -> Void)?

    @IBOutlet var tableView: UITableView?

    private weak var sendButton: StageButton?
    private weak var currentLowgroundTextField: UITextField?

    private var forms: [(String, [TextFieldCellData])] = []
    private var progress: KYCPersonalInfoProgress = KYCPersonalInfoProgress()

    private var state: KYCApprovingState = .initial

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustForKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)

        //migratingNavigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        forms = [
            ("Personal info",
             [TextFieldCellData(placeholder: "Email",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.email = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "First name",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.firstName = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "Last name",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.lastName = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "Date of birth",
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
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.country = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "City",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.city = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "State / Region",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.region = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "Street",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.street = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "House number",
                                action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.house = textField.text }),
                                beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
                ),
              TextFieldCellData(placeholder: "Postal code",
                                 action: .editingChanged({ [weak self]
                                    textField in

                                    self?.progress.postalCode = textField.text }),
                                 beginEditingAction: { [weak self]
                                    textField in

                                    self?.checkTextFieldPosition(textField)}
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

    func prepare(state: KYCApprovingState) {
        self.state = state

        switch state {
        case .initial:
            sendButton?.custom.changeState(to: 0, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "chevronRight")
                imageView.tintColor = .darkIndigo
            })
        case .onVerification:
            sendButton?.custom.changeState(to: 1, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icTime")
                imageView.tintColor = .white
            })
        case .verified:
            sendButton?.custom.changeState(to: 2, indicatorBlock: { imageView in
                imageView.image = #imageLiteral(resourceName: "icCheck")
                imageView.tintColor = .white
            })
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

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == forms.count - 1 else {
            return nil
        }

        let footer = UIView()
        footer.backgroundColor = .clear

        let sendButton = StageButton(type: .custom)
        sendButton.custom.setup(type: .small, stages: [
            StageDescription(id: nil, idTextColor: nil, description: "Send", descriptionTextColor: .white, backgroundColor: .lightblue)])

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
        guard section == forms.count - 1 else {
            return 0.0
        }

        return 76.0
    }

    private func checkTextFieldPosition(_ textField: UITextField) {
        guard let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window else {
            return
        }

        let position = textField.convert(textField.bounds.origin, to: window)

        if position.y + textField.bounds.height + 15 > window.bounds.height - 350 {
            currentLowgroundTextField = textField
        } else {
            currentLowgroundTextField = nil
        }
    }

    @objc
    private func sendButtonTouchUpInsideEvent(_ sender: Any) {
        dismissKeyboard()
        onSend?(.onVerification)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let _ = currentLowgroundTextField, let scrollView = tableView else {
            return
        }

        let userInfo = notification.userInfo!

        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
