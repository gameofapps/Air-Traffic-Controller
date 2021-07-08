//
//  Plane.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-07.
//

import UIKit

struct Plane {

    // Public properties
    var velocity: PlaneSpeed = .speed1
    var path: UIBezierPath? = nil

    // Public read-only properties
    private (set) public var percentageComplete: CGFloat = 0.0

    var position: CGPoint {
        guard let path = path else { return CGPoint.zero }
        return path.mx_point(atFractionOfLength: percentageComplete)
    }

    // Public methods
    mutating func move() {
        guard let path = path else { return }
        let speed = velocity.rawValue
        let length = path.mx_length
        let fraction = CGFloat(speed) / length
        percentageComplete += fraction
    }
}

enum PlaneSpeed: Int {
    
    case speed1 = 10
    case speed2 = 15
    case speed3 = 20
    case speed4 = 25
    case speed5 = 30
}
