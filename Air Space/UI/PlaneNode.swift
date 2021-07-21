//
//  PlaneNode.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-21.
//

import UIKit
import SpriteKit

protocol PlaneNodeDelegate {
    
    func didTouchDown(planeNode: PlaneNode)
    func didTouchUpInside(planeNode: PlaneNode)
    func didTouchUpOutside(planeNode: PlaneNode)
}

class PlaneNode: SKSpriteNode {

    // Public properties
    var delegate: PlaneNodeDelegate? = nil

    // Private properties
    private var touchLocationLast: CGPoint? = nil

    // Initializer
    init() {
        let texture = SKTexture(imageNamed: "airplane")
        super.init(texture: texture, color: .clear, size: texture.size())
        size = CGSize(width: PlaneViewModel.width, height: PlaneViewModel.height)
        isUserInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Handle touch events
extension PlaneNode {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let parentNode = self.parent else { return }
        let touchPoint = touch.location(in: parentNode)
        if contains(touchPoint) {
            touchLocationLast = touchPoint
            touchedDown()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let parentNode = self.parent else { return }
        let touchPoint = touch.location(in: parentNode)
        touchLocationLast = touchPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let parentNode = self.parent else { return }
        let touchPoint = touch.location(in: parentNode)
        touchLocationLast = touchPoint
        if contains(touchPoint) {
            touchedUpInside()
        }
        else {
            touchedUpOutside()
        }
    }

    private func touchedDown() {
        delegate?.didTouchDown(planeNode: self)
    }

    private func touchedUpInside() {
        delegate?.didTouchUpInside(planeNode: self)
    }

    private func touchedUpOutside() {
        delegate?.didTouchUpOutside(planeNode: self)
    }
}
