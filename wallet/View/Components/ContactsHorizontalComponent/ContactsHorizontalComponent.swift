//
//  ContactsHorizontalComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

class ContactsHorizontalComponent: Component, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var searchTextField: SearchTextField?
    @IBOutlet private var contactsCollectionView: UICollectionView?

    private var contacts: [ContactData] = []
    private var filteredContacts: [ContactData] = []
    private var title: String = ""

    override func initFromNib() {
        super.initFromNib()

        contactsCollectionView?.register(ContactItemComponent.self , forCellWithReuseIdentifier: "ContactItemComponent")
        contactsCollectionView?.delegate = self
        contactsCollectionView?.dataSource = self

        searchTextField?.addTarget(self, action: #selector(searchTextFieldEditingChanged(_:)), for: .editingChanged)
    }

    override func setupStyle() {
        super.setupStyle()

        titleLabel?.font = UIFont.walletFont(ofSize: 22.0, weight: .bold)
        titleLabel?.textAlignment = .left
        titleLabel?.textColor = .white
        titleLabel?.text = title

        searchTextField?.font = UIFont.walletFont(ofSize: 16, weight: .medium)
        searchTextField?.textAlignment = .left
        searchTextField?.textColor = .white
        searchTextField?.backgroundColor = UIColor.cornflower.withAlphaComponent(0.12)
        searchTextField?.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                    attributes: [
                                                                        .font: UIFont.walletFont(ofSize: 16, weight: .medium),
                                                                        .foregroundColor: UIColor.skyBlue.withAlphaComponent(0.4)
                                                                    ])
        contactsCollectionView?.backgroundColor = .clear
        contactsCollectionView?.clipsToBounds = false
    }

    func prepare(title: String, contacts: [ContactData]) {
        prepare(contacts: contacts)

        self.title = title
        componentWasPrepared()
    }

    func prepare(contacts: [ContactData]) {
        self.contacts = contacts
        self.filteredContacts = contacts
        componentWasPrepared()
    }

    private func componentWasPrepared() {
        titleLabel?.text = title
        contactsCollectionView?.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredContacts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactItemComponent", for: indexPath)

        guard let cell = _cell as? ContactItemComponent else {
            fatalError()
        }

        let contact = filteredContacts[indexPath.item]

        if let data = contact.avatarData, let image = UIImage(data: data) {
            cell.configure(avatar: image, name: contact.name)
        } else {
            let image = LetterImage(bounds: CGRect(origin: .zero, size: CGSize(width: 32.0, height: 32.0))).generate(string: contact.name, color: UIColor.cornflower.withAlphaComponent(0.4), circular: true, textAttributes: [.font: UIFont.walletFont(ofSize: 12.0, weight: .medium), .foregroundColor: UIColor.white]) ?? #imageLiteral(resourceName: "icEmpty")
            cell.configure(avatar: image, name: contact.name)
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.height - 16.0, height: collectionView.bounds.height)
    }

    @objc
    private func searchTextFieldEditingChanged(_ sender: SearchTextField) {
        guard let searchRequest = sender.text else {
            filteredContacts = contacts
            contactsCollectionView?.reloadData()

            return
        }

        guard searchRequest != "" else {
            filteredContacts = contacts
            contactsCollectionView?.reloadData()

            return
        }

        filteredContacts = contacts.filter {
            $0.name.lowercased().contains(searchRequest.lowercased())
        }

        contactsCollectionView?.performBatchUpdates({ [weak self] in
            let indexSet = IndexSet(integersIn: 0...0)
            self?.contactsCollectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
}
