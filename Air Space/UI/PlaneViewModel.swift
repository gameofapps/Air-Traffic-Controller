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
    var planeButton: UIButton?
    
    var collided: Bool {
        didSet {
            if collided {
                let planeImage = UIImage(named: "airplane-red")
                planeButton?.setImage(planeImage, for: .normal)
                let planeSelectedImage = UIImage(named: "airplane-red")
                planeButton?.setImage(planeSelectedImage, for: .selected)
            }
            else {
                let planeImage = UIImage(named: "airplane")
                planeButton?.setImage(planeImage, for: .normal)
                let planeSelectedImage = UIImage(named: "airplane-black")
                planeButton?.setImage(planeSelectedImage, for: .selected)
            }
        }
    }

    static let width: CGFloat = 80.0
    static let height: CGFloat = 81.0
    
    init() {
        collided = false
    }
}
