//
//  Plane.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-07.
//

import UIKit

struct Plane : Equatable {

    // Public properties
    var velocity: PlaneSpeed = .speed3
    var path: UIBezierPath? = nil

    private var uuid = UUID()
}

enum PlaneSpeed: CGFloat {
    
    case speed1 = 20
    case speed2 = 30
    case speed3 = 40
    case speed4 = 50
    case speed5 = 60
}
