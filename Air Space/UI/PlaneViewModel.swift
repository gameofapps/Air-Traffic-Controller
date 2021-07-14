//
//  PlaneViewModel.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-13.
//

import UIKit

struct PlaneViewModel {

    var plane = Plane(initialPosition: CGPoint.zero)
    var pathShape = CAShapeLayer()
    var planeView: UIView?
    
    static let width: CGFloat = 80.0
    static let height: CGFloat = 81.0
}
