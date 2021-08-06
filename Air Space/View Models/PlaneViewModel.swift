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

    // Public properties
    var plane = Plane()
    var pathShape = CAShapeLayer()
    var planeNode: PlaneNode
    var origin: BeaconName
    var destination: BeaconName
    weak var delegate: PlaneViewModelDelegate? = nil

    static let width: CGFloat = 80.0
    static let height: CGFloat = 80.0

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
    
    init(planeNode: PlaneNode, origin: BeaconName, destination: BeaconName) {
        self.planeNode = planeNode
        self.origin = origin
        self.destination = destination
        print("Plane origin: \(origin), destination: \(destination)")
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