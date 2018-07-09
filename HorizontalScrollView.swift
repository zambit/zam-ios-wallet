//
//  HorizontalScrollView.swift
//  wallet
//
//  Created by  me on 06/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

class HorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    
    var onPageSelected: ((Int)->Void)?
    
    
    public func select(page: Int) {
        self.scrollTo(index: page)
        self.onPageSelected?(page)
    }
    
    override func awakeFromNib() {
        delegate = self
        showsHorizontalScrollIndicator = false
        bounces = false
        self.decelerationRate = 0
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
        self.scrollToBigger()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollToBigger()
        }
    }
    func scrollToBigger() {
        let x = contentOffset.x / self.frame.width + 0.5
        let i = Int(x)
        self.select(page: i)
    }
    func scrollTo(index: Int) {
        let x2 = self.frame.width * CGFloat(index)
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
