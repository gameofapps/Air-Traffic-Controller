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
    
    // Public methods
    func setMotion(on bezierPath: UIBezierPath) {
        guard let scene = scene else { return }
        let points = bezierPath.points()
        var transformedPoints = [CGPoint]()
        for point in points {
            if let transformedPoint = scene.view?.convert(point, to: scene) {
                transformedPoints.append(transformedPoint)
            }
        }

        guard transformedPoints.count > 1 else { return }
        let transformedBezierPath = UIBezierPath()
        transformedBezierPath.move(to: transformedPoints[0])
        for i in 1 ..< transformedPoints.count {
            transformedBezierPath.addLine(to: transformedPoints[i])
        }

        let move = SKAction.follow(transformedBezierPath.cgPath, asOffset: false, orientToPath: true, speed: 20)
        run(move)
    }

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

    // Private properties
    private var touchLocationLast: CGPoint? = nil
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
