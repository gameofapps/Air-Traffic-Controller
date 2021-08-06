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
    var defaultSpeed: CGFloat = PlaneSpeed.speed3.rawValue
    
    var isSelected: Bool {
        didSet {
            guard !isCollided else { return }
            if isSelected {
                texture = SKTexture(imageNamed: "airplane-black")
            }
            else {
                texture = SKTexture(imageNamed: PlaneNode.imageName(for: destination))
            }
        }
    }
    
    var isCollided: Bool {
        didSet {
            if isCollided {
                texture = SKTexture(imageNamed: "airplane-red")
            }
            else if isSelected {
                texture = SKTexture(imageNamed: "airplane-black")
            }
            else {
                texture = SKTexture(imageNamed: PlaneNode.imageName(for: destination))
            }
        }
    }

    var cartesianCoordinates: CGPoint {
        guard let scene = scene else { return CGPoint.zero }
        guard let cartesianCoordinates = scene.view?.convert(position, from: scene) else { return CGPoint.zero }
        return cartesianCoordinates
    }

    // Public methods
    func setMotion(on bezierPath: UIBezierPath, transform: Bool) {
        guard let scene = scene else { return }
        let points = bezierPath.points()
        var transformedPoints = [CGPoint]()
        for point in points {
            if transform {
                if let transformedPoint = scene.view?.convert(point, to: scene) {
                    transformedPoints.append(transformedPoint)
                }
            }
            else {
                transformedPoints.append(point)
            }
        }

        guard transformedPoints.count > 1 else { return }
        let transformedBezierPath = UIBezierPath()
        transformedBezierPath.move(to: transformedPoints[0])
        for i in 1 ..< transformedPoints.count {
            transformedBezierPath.addLine(to: transformedPoints[i])
        }

        removeAllActions()
        inFreeFlight = false
        let move = SKAction.follow(transformedBezierPath.cgPath, asOffset: false, orientToPath: true, speed: defaultSpeed)
        run(move) { [weak self] in
            guard let defaultSpeed = self?.defaultSpeed else { return }
            let tangentAngle = transformedBezierPath.mx_tangentAngle(atFractionOfLength: 1.0)
            let x = cos(tangentAngle) * defaultSpeed
            let y = -sin(tangentAngle) * defaultSpeed
            print("End angle: \(tangentAngle), x: \(x), y: \(y)")
            
            self?.physicsBody?.velocity = CGVector(dx: x, dy: y)
            self?.inFreeFlight = true
        }
    }

    func updateFreeFlightIfNeeded() {
        guard inFreeFlight else { return }
        guard let xVelocity = physicsBody?.velocity.dx, let yVelocity = physicsBody?.velocity.dy else { return }
        let magnitude: CGFloat = sqrt(xVelocity*xVelocity + yVelocity*yVelocity)
        let angle: CGFloat = atan2(yVelocity, xVelocity)
        if magnitude < defaultSpeed {
            physicsBody?.velocity = CGVector(dx: CGFloat(cos(angle)*defaultSpeed), dy: CGFloat(sin(angle)*defaultSpeed))
        }
    }

    // Initializer
    init(destination: BeaconName) {
        let texture = SKTexture(imageNamed: PlaneNode.imageName(for: destination))
        self.destination = destination
        isCollided = false
        isSelected = false
        super.init(texture: texture, color: .clear, size: texture.size())
        size = CGSize(width: PlaneViewModel.width, height: PlaneViewModel.height)
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.mass = 0.1
        physicsBody?.contactTestBitMask = physicsBody?.collisionBitMask ?? 0xFFFFFFFF
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Private properties
    private var touchLocationLast: CGPoint? = nil
    private var inFreeFlight = false
    private var destination: BeaconName
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

extension PlaneNode {

    private static func imageName(for beaconName: BeaconName) -> String {
        switch beaconName {
        case .beaconAirport:
            return "airplane-blue"
        case .beaconLeft:
            return "airplane-orange"
        case .beaconRight:
            return "airplane-cyan"
        case .beaconTop:
            return "airplane-purple"
        case .beaconBottom:
            return "airplane-yellow"
        }
    }
    
    private static let collidedImageName = "airplane-red"
}
