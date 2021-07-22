//
//  UIBezierPath+Utility.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-21.
//

import UIKit

extension UIBezierPath {
    
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil

        self.cgPath.forEach { element in
            // Just want the first one, but we have to look at everything
            guard firstPoint == nil else { return }
            assert(element.type == .moveToPoint, "Expected the first point to be a move")
            firstPoint = element.points.pointee
        }
        return firstPoint
    }
    
    func points() -> [CGPoint] {
        let length = self.mx_length
        let stepSize = 1 / length
        var points = [CGPoint]()
        if let firstPoint = firstPoint() {
            points.append(firstPoint)
        }
        var fraction = stepSize
        while fraction <= 1.0 {
            let point = mx_point(atFractionOfLength: fraction)
            points.append(point)
            fraction += stepSize
        }
        return points
    }
}
