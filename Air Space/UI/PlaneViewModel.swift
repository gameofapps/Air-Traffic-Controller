//
//  PlaneViewModel.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-13.
//

import UIKit
import SpriteKit

struct PlaneViewModel {

    var plane = Plane(initialPosition: CGPoint.zero)
    var pathShape = CAShapeLayer()
    var planeNode: PlaneNode
    
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
    }
}
//
//extension PlaneViewModel : Hashable {
//    
//    static func == (lhs: PlaneViewModel, rhs: PlaneViewModel) -> Bool {
//        return lhs.plane == rhs.plane
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(plane)
//    }
//}
