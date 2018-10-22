//
//  CloudLayer.swift
//  wallet
//
//  Created by Alexander Ponomarev on 19/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class CloudLayer: CAShapeLayer {

    var text: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    var additional: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }

    override var frame: CGRect {
        didSet {
            topTextLayer?.frame = CGRect(x: 7.0, y: 4.0, width: frame.width - 7.0 - 5.0, height: 15.0)
            bottomTextLayer?.frame = CGRect(x: 7.0, y: 17.0, width: frame.width - 7.0 - 5.0, height: frame.height - 17.0 - 3.0)
        }
    }

    private var topTextLayer: CATextLayer?
    private var bottomTextLayer: CATextLayer?

    override func draw(in ctx: CGContext) {
        self.sublayers?.forEach {
            if $0.name == "topTextLayer" ||
                $0.name == "bottomTextLayer" {
                $0.removeFromSuperlayer()
            }
        }

        let topTextLayer = CATextLayer()
        topTextLayer.frame = CGRect(x: 7.0, y: 4.0, width: frame.width - 7.0 - 5.0, height: 15.0)
        topTextLayer.string = text
        topTextLayer.alignmentMode = .left
        topTextLayer.font = UIFont.walletFont(ofSize: 10, weight: .medium)
        topTextLayer.fontSize = 10
        topTextLayer.foregroundColor = UIColor.blueGrey.cgColor
        topTextLayer.contentsScale = UIScreen.main.scale
        topTextLayer.isWrapped = true
        topTextLayer.truncationMode = .end
        topTextLayer.name = "topTextLayer"

        addSublayer(topTextLayer)

        self.topTextLayer = topTextLayer


        let bottomTextLayer = CATextLayer()
        bottomTextLayer.frame = CGRect(x: 7.0, y: 17.0, width: frame.width - 7.0 - 5.0, height: frame.height - 17.0 - 3.0)
        bottomTextLayer.string = additional
        bottomTextLayer.alignmentMode = .left
        bottomTextLayer.font = UIFont.walletFont(ofSize: 8.0, weight: .regular)
        bottomTextLayer.fontSize = 8
        bottomTextLayer.foregroundColor = UIColor.blueGrey.cgColor
        bottomTextLayer.contentsScale = UIScreen.main.scale
        bottomTextLayer.isWrapped = true
        bottomTextLayer.truncationMode = .end
        bottomTextLayer.name = "bottomTextLayer"

        addSublayer(bottomTextLayer)

        self.bottomTextLayer = bottomTextLayer
    }
}
