//
//  UIBezierPath+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 02/10/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIBezierPath
{

    @discardableResult
    func interpolatePointsWithHermite(interpolationPoints : [CGPoint], alpha: CGFloat = 1.0/3.0) -> [CGPoint]
    {
        guard !interpolationPoints.isEmpty else { return [] }
        self.move(to: interpolationPoints[0])

        let n = interpolationPoints.count - 1

        var points: [CGPoint] = [interpolationPoints[0]]

        for index in 0..<n
        {
            var currentPoint = interpolationPoints[index]
            var nextIndex = (index + 1) % interpolationPoints.count
            var prevIndex = index == 0 ? interpolationPoints.count - 1 : index - 1
            var previousPoint = interpolationPoints[prevIndex]
            var nextPoint = interpolationPoints[nextIndex]
            let endPoint = nextPoint
            var mx : CGFloat
            var my : CGFloat

            if index > 0
            {
                mx = (nextPoint.x - previousPoint.x) / 2.0
                my = (nextPoint.y - previousPoint.y) / 2.0
            }
            else
            {
                mx = (nextPoint.x - currentPoint.x) / 2.0
                my = (nextPoint.y - currentPoint.y) / 2.0
            }

            let controlPoint1 = CGPoint(x: currentPoint.x + mx * alpha, y: currentPoint.y + my * alpha)
            currentPoint = interpolationPoints[nextIndex]
            nextIndex = (nextIndex + 1) % interpolationPoints.count
            prevIndex = index
            previousPoint = interpolationPoints[prevIndex]
            nextPoint = interpolationPoints[nextIndex]

            if index < n - 1
            {
                mx = (nextPoint.x - previousPoint.x) / 2.0
                my = (nextPoint.y - previousPoint.y) / 2.0
            }
            else
            {
                mx = (currentPoint.x - previousPoint.x) / 2.0
                my = (currentPoint.y - previousPoint.y) / 2.0
            }

            let controlPoint2 = CGPoint(x: currentPoint.x - mx * alpha, y: currentPoint.y - my * alpha)

            self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            points.append(endPoint)
        }

        return points
    }
}
