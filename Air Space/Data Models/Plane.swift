//
//  Plane.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-07.
//

import UIKit

struct Plane : Equatable {

    // Public properties
    var velocity: PlaneSpeed = .speed1
    var path: UIBezierPath? = nil {
        didSet {
            if path != nil {
//                initialPosition = nil
            }
        }
    }

    private var uuid = UUID()
//    // Public read-only properties
//    private (set) public var percentageComplete: CGFloat = 0.0
//
//    var centrePosition: CGPoint {
//        if let path = path {
//            let centrePosition = path.mx_point(atFractionOfLength: percentageComplete)
//            return centrePosition
//        }
//        else if let initialPosition = initialPosition {
//            return initialPosition
//        }
//        else {
//            return CGPoint.zero
//        }
//    }
//
//    // Public methods
//    init(initialPosition: CGPoint) {
//        self.initialPosition = initialPosition
//    }
//
//    mutating func resetPath() {
//        percentageComplete = 0.0
//    }
//
//    mutating func move() {
//        guard let path = path else { return }
//        let speed = velocity.rawValue
//        let length = path.mx_length
//        let fraction = CGFloat(speed) / length
//        percentageComplete += fraction
//    }
//
//    func headingInRadians() -> CGFloat {
//        let percentageComplete = self.percentageComplete <= 0.0 ? 0.01 : self.percentageComplete
//        guard let tangent = path?.mx_tangentAngle(atFractionOfLength: percentageComplete) else {
//            return 0.0
//        }
//        return CGFloat(Double.pi / 2) - tangent
//    }
//
//    // Private properties
//    private var initialPosition: CGPoint? = nil
}

enum PlaneSpeed: Int {
    
    case speed1 = 10
    case speed2 = 15
    case speed3 = 20
    case speed4 = 25
    case speed5 = 30
}
