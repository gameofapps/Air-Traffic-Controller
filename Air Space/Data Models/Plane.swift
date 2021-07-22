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
    var path: UIBezierPath? = nil

    private var uuid = UUID()
}

enum PlaneSpeed: Int {
    
    case speed1 = 10
    case speed2 = 15
    case speed3 = 20
    case speed4 = 25
    case speed5 = 30
}
