//
//  Array+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Array {

    func subarray(from: Int, to: Int) -> Array<Element> {
        let idx1 = index(startIndex, offsetBy: Swift.max(0, from))
        let idx2 = index(startIndex, offsetBy: Swift.min(self.count, to))
        return Array(self[idx1..<idx2])
    }
}

extension Array {

    @discardableResult
    mutating func append(_ newArray: Array) -> CountableRange<Int> {
        let range = count..<(count + newArray.count)
        self += newArray
        return range
    }

    @discardableResult
    mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
        let mIndex = Swift.max(0, index)
        let start = Swift.min(count, mIndex)
        let end = start + newArray.count

        let left = self[0..<start]
        let right = self[start..<count]
        self = left + newArray + right
        return start..<end
    }

    mutating func remove<T: AnyObject> (_ element: T) {
        let anotherSelf = self

        removeAll(keepingCapacity: true)

        anotherSelf.each { (index: Int, current: Element) in
            if (current as! T) !== element {
                self.append(current)
            }
        }
    }

    func each(_ exe: (Int, Element) -> ()) {
        for (index, item) in enumerated() {
            exe(index, item)
        }
    }
}
