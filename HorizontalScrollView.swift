//
//  HorizontalScrollView.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HorizontalScrollView: UIScrollView {
    
    var pages: [UIView] = [] {
        willSet {
            for view in pages {
                view.removeFromSuperview()
            }
        }
        didSet {
            for view in pages {
                self.addSubview(view)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = self.frame.width
        let height = self.frame.height
        for j in 0..<pages.count {
            pages[j].frame = CGRect(x: width * CGFloat(j), y: 0, width: width, height: height)
        }
        self.contentSize = CGSize(width: width * CGFloat(pages.count), height: height)
    }
}
