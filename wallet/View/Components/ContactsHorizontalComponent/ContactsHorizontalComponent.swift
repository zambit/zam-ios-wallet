//
//  ContactsHorizontalComponent.swift
//  wallet
//
//  Created by Alexander Ponomarev on 22/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol ContactsHorizontalComponentDelegate: class {

    func contactsHorizontalComponent(_ contactsHorizontalComponent: ContactsHorizontalComponent, itemWasTapped contactData: ContactData)
}

class ContactsHorizontalComponent: Component, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchTextFieldDelegate {

    weak var delegate: ContactsHorizontalComponentDelegate?

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet var searchTextField: SearchTextField?
    @IBOutlet var contactsCollectionView: UICollectionView?

    private var contacts: [ContactData] = []
    private var filteredContacts: [ContactData] = []
    private var title: String = "Send by phone"
    
    override func initFromNib() {
        super.initFromNib()

        contactsCollectionView?.register(ContactItemComponent.self , forCellWithReuseIdentifier: "ContactItemComponent")
        contactsCollectionView?.delegate = self
        contactsCollectionView?.dataSource = self

        searchTextField?.searchDelegate = self
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
            let image = LettersImageGenerator(bounds: CGRect(origin: .zero, size: CGSize(width: 32.0, height: 32.0))).generate(string: contact.name, color: UIColor.cornflower.withAlphaComponent(0.4), circular: true, textAttributes: [.font: UIFont.walletFont(ofSize: 12.0, weight: .medium), .foregroundColor: UIColor.white]) ?? #imageLiteral(resourceName: "icEmpty")
            cell.configure(avatar: image, name: contact.name)
        }

        cell.onTap = {
            [weak self] in

            guard let strongSelf = self else {
                return
            }

            strongSelf.delegate?.contactsHorizontalComponent(strongSelf, itemWasTapped: contact)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let contactCell = cell as? ContactItemComponent else {
            fatalError()
        }

        contactCell.setupStyle()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88.0, height: 88.0)
    }

    func searchTextFieldEditingChanged(_ searchTextField: SearchTextField, query: String) {
        if query != "" {
            filteredContacts = contacts.filter {
                $0.name.split(separator: " ").contains {
                    $0.lowercased().hasPrefix(query.lowercased())
                }
            }
        } else {
            filteredContacts = contacts
        }

        contactsCollectionView?.performBatchUpdates({ [weak self] in
            let indexSet = IndexSet(integersIn: 0...0)
            self?.contactsCollectionView?.reloadSections(indexSet)
        }, completion: nil)
    }
}
