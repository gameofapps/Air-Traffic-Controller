//
//  PlaneViewModel.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-13.
//

import UIKit
import SpriteKit

protocol PlaneViewModelDelegate : AnyObject {
    
    func didSelect(planeViewModel: PlaneViewModel)
}

class PlaneViewModel {

//    var plane = Plane(initialPosition: CGPoint.zero)
    var plane = Plane()
    var pathShape = CAShapeLayer()
    var planeNode: PlaneNode
    weak var delegate: PlaneViewModelDelegate? = nil
    
    var isSelected: Bool {
        didSet {
            guard !isCollided else { return }
            if isSelected {
                planeNode.texture = SKTexture(imageNamed: "airplane-black")
            }
            else {
                planeNode.texture = SKTexture(imageNamed: "airplane")
            }
        }
    }
    
    var isCollided: Bool {
        didSet {
            if isCollided {
                planeNode.texture = SKTexture(imageNamed: "airplane-red")
            }
            else if isSelected {
                planeNode.texture = SKTexture(imageNamed: "airplane-black")
            }
            else {
                planeNode.texture = SKTexture(imageNamed: "airplane")
            }
        }
    }

    static let width: CGFloat = 80.0
    static let height: CGFloat = 81.0
    
    init(planeNode: PlaneNode) {
        self.planeNode = planeNode
        isSelected = false
        isCollided = false
        self.planeNode.delegate = self
    }
}

extension PlaneViewModel : Equatable {
    
    static func == (lhs: PlaneViewModel, rhs: PlaneViewModel) -> Bool {
        return lhs.plane == rhs.plane
    }
}

extension PlaneViewModel : PlaneNodeDelegate {
    
    func didTouchDown(planeNode: PlaneNode) {}
    func didTouchUpOutside(planeNode: PlaneNode) {}

    func didTouchUpInside(planeNode: PlaneNode) {
        delegate?.didSelect(planeViewModel: self)
    }
}
