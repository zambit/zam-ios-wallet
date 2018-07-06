//
//  HorizontalScrollView.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    
    override func awakeFromNib() {
        delegate = self
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("deceleration end")
        self.scrollToBigger()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("did, will:\(decelerate)")
        if !decelerate {
            self.scrollToBigger()
        }
    }
    func scrollToBigger() {
        let x = contentOffset.x / self.frame.width + 0.5
        let i = Int(x)
        let x2 = self.frame.width * CGFloat(i)
        setContentOffset(CGPoint(x: x2, y: 0), animated: true)
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
