//
//  CreatePinComponent.swift
//  wallet
//
//  Created by  me on 03/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

protocol CreatePinComponentDelegate: class {

    func createPinComponent(_ createPinComponent: CreatePinComponent, succeedWithPin pin: String)

    func createPinComponentWrongConfirmation(_ createPinComponent: CreatePinComponent)

}

class CreatePinComponent: Component, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    @IBOutlet private var collectionView: UICollectionView?
    private var heightConstraint: NSLayoutConstraint?

    private var pinText: String = ""
    private var pinConfirmationText: String = ""

    private var currentPinStage: CreatePinStageItem? {
        let indexPath = IndexPath(item: 0, section: currentStageIndex)
        guard let item = collectionView?.cellForItem(at: indexPath) else {
            return nil
        }

        return (item as! CreatePinStageItem)
    }
    private var currentStageIndex: Int = 0

    private var createPinStages: [CreatePinStageData] = []

    weak var delegate: CreatePinComponentDelegate?

    override func initFromNib() {
        super.initFromNib()

        switch UIDevice.current.screenType {
        case .extraSmall, .small:
            self.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            break
        case .medium:
            self.heightAnchor.constraint(equalToConstant: 145.0).isActive = true
            break
        case .extra, .plus:
            self.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
            break
        case .unknown:
            break
        }

        createPinStages = [
            CreatePinStageData(title: "Create PIN-code", codeLength: 4),
            CreatePinStageData(title: "Confirm PIN-code", codeLength: 4)
        ]

        collectionView?.register(CreatePinStageItem.self, forCellWithReuseIdentifier: "CreatePinStageItem")

        collectionView?.delegate = self
        collectionView?.dataSource = self

        self.clipsToBounds = false
        self.collectionView?.clipsToBounds = false
    }

    override func setupStyle() {
        super.setupStyle()

        collectionView?.backgroundColor = .clear
    }

    private var completionActionsAfterScroll: [() -> Void] = []

    func enterTheKey(_ key: String) {
        guard let filled = currentPinStage?.dotsFieldComponent?.fillLast(), filled else {
            switch currentStageIndex {
            case 0:
                moveToNextStage(animated: true) {
                    [weak self] in
                    self?.enterTheKey(key)
                }
                return
            case 1:
                return
            default:
                fatalError()
            }
        }

        switch currentStageIndex {
        case 0:
            pinText.append(key)

            if let stageDotsField = currentPinStage?.dotsFieldComponent,
                stageDotsField.filledCount == stageDotsField.dotsMaxCount {

                moveToNextStage(animated: true)
            }
        case 1:
            pinConfirmationText.append(key)

            if let stageDotsField = currentPinStage?.dotsFieldComponent,
                stageDotsField.filledCount == stageDotsField.dotsMaxCount {

                currentPinStage?.dotsFieldComponent?.fillingEnabled = false

                if pinText == pinConfirmationText {
                    currentPinStage?.dotsFieldComponent?.showSuccess()
                    delegate?.createPinComponent(self, succeedWithPin: pinText)
                } else {
                    delegate?.createPinComponentWrongConfirmation(self)
                    currentPinStage?.dotsFieldComponent?.showFailure {
                        [weak self] in

                        self?.pinConfirmationText = ""
                        self?.currentPinStage?.dotsFieldComponent?.unfillAll()
                        self?.currentPinStage?.dotsFieldComponent?.fillingEnabled = true
                    }
                }
            }
        default:
            fatalError()
        }
    }

    func removeLast() {
        guard let unfilled = currentPinStage?.dotsFieldComponent?.unfillLast(), unfilled else {
            switch currentStageIndex {
            case 0:
                return
            case 1:
                moveToPreviousStage(animated: true)
                return
            default:
                fatalError()
            }
        }

        switch currentStageIndex {
        case 0:
            pinText.removeLast()
        case 1:
            pinConfirmationText.removeLast()
        default:
            fatalError()
        }
    }

    func moveToNextStage(animated: Bool, completion handler: @escaping () -> Void = {}) {
        currentStageIndex += 1

        completionActionsAfterScroll.append(handler)

        let indexPath = IndexPath(item: 0, section: currentStageIndex)

        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    func moveToPreviousStage(animated: Bool) {
        guard currentStageIndex > 0 else {
            return
        }

        currentStageIndex -= 1

        let indexPath = IndexPath(item: 0, section: currentStageIndex)

        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    // UICollectionView dataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return createPinStages.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreatePinStageItem", for: indexPath)

        guard let cell = _cell as? CreatePinStageItem else {
            fatalError()
        }

        cell.configure(data: createPinStages[indexPath.section])
        return cell
    }

    // UICollectionView delegate flow layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    // UIScrollView delegate

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        completionActionsAfterScroll.forEach { _ in
            completionActionsAfterScroll.popLast()?()
        }
    }
}

struct CreatePinStageData {
    var title: String
    var codeLength: Int
}
