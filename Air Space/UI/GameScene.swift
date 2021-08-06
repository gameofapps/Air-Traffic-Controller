//
//  GameScene.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-21.
//

import UIKit
import SpriteKit

protocol GameSceneDelegate : AnyObject {
    
    func didCollide(gameScene: GameScene, planeA: PlaneNode, planeB: PlaneNode)
    func didCollide(gameScene: GameScene, plane: PlaneNode, beacon: BeaconNode)
}

class GameScene: SKScene {

    // Public properties
    weak var gameSceneDelegate: GameSceneDelegate? = nil
    
    var score: Int = 0 {
        didSet {
            guard let scoreBoard = scoreBoard else { return }
            scoreBoard.text = "Score: \(score)"
        }
    }

    // Public methods
    func setupBoard() {
        let leftBeaconNode = BeaconNode(beaconName: .beaconLeft)
        leftBeaconNode.position = getBeaconPosition(for: .beaconLeft)
        addChild(leftBeaconNode)
        let leftBeaconViewModel = BeaconViewModel(beaconNode: leftBeaconNode, name: .beaconLeft, spawnPosition: spawnPosition(for: leftBeaconNode, name: .beaconLeft))
        beacons.append(leftBeaconViewModel)

        let rightBeaconNode = BeaconNode(beaconName: .beaconRight)
        rightBeaconNode.position = getBeaconPosition(for: .beaconRight)
        addChild(rightBeaconNode)
        let rightBeaconViewModel = BeaconViewModel(beaconNode: rightBeaconNode, name: .beaconRight, spawnPosition: spawnPosition(for: rightBeaconNode, name: .beaconRight))
        beacons.append(rightBeaconViewModel)

        let airportBeaconNode = BeaconNode(beaconName: .beaconAirport)
        airportBeaconNode.position = getBeaconPosition(for: .beaconAirport)
        addChild(airportBeaconNode)
        let airportBeaconViewModel = BeaconViewModel(beaconNode: airportBeaconNode, name: .beaconAirport, spawnPosition: spawnPosition(for: airportBeaconNode, name: .beaconAirport))
        beacons.append(airportBeaconViewModel)

        scoreBoard = SKLabelNode(fontNamed: "Chalkduster")
        addChild(scoreBoard!)
        scoreBoard?.position = CGPoint(x: size.width / 2.0, y: size.height - navigationBarHeight - 12.0)
        scoreBoard?.zPosition = -1.0
        score = 0
    }
    
    func spawnNewPlane(defaultSpeed: PlaneSpeed) -> PlaneViewModel? {
        guard let originBeacon = getRandomBeacon(), let destinationBeacon = getRandomBeacon() else { return nil }

        let planeNode = PlaneNode(destination: destinationBeacon.beacon.name, defaultSpeed: defaultSpeed)
        planeNode.position = originBeacon.spawnPosition
        addChild(planeNode)

        let planeViewModel = PlaneViewModel(planeNode: planeNode, origin: originBeacon.beacon.name, destination: destinationBeacon.beacon.name)
        planes.append(planeViewModel)

        planeNode.setMotion(on: initialPath(for: originBeacon), transform: false)

        return planeViewModel
    }
    
    func remove(plane: PlaneViewModel) {
        var foundIndex: Int? = nil
        for (index, planeViewModel) in planes.enumerated() {
            if planeViewModel == plane {
                foundIndex = index
                break
            }
        }
        
        guard let foundIndex = foundIndex else { return }
        let planeViewModel = planes[foundIndex]
        planeViewModel.planeNode.removeFromParent()
        planes.remove(at: foundIndex)
    }

    func viewModel(for planeNode: PlaneNode) -> PlaneViewModel? {
        for planeViewModel in planes {
            if planeViewModel.planeNode == planeNode {
                return planeViewModel
            }
        }
        return nil
    }
    
    func viewModel(for beaconNode: BeaconNode) -> BeaconViewModel? {
        for beaconViewModel in beacons {
            if beaconViewModel.beaconNode == beaconNode {
                return beaconViewModel
            }
        }
        return nil
    }

    // Private properties
    private var planes = [PlaneViewModel]()
    private var beacons = [BeaconViewModel]()
    private var scoreBoard: SKLabelNode? = nil
    private let navigationBarHeight: CGFloat = 112.0
}

// MARK: - Overridden SKScene properties / methods
extension GameScene {
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        backgroundColor = .clear

        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
    }

    override func update(_ currentTime: TimeInterval) {
        for planeViewModel in planes {
            planeViewModel.planeNode.updateFreeFlightIfNeeded()
        }
    }
}

// MARK: - SKPhysicsContactDelegate methods
extension GameScene : SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if let firstPlane = contact.bodyA.node as? PlaneNode {
            if let secondPlane = contact.bodyB.node as? PlaneNode {
                gameSceneDelegate?.didCollide(gameScene: self, planeA: firstPlane, planeB: secondPlane)
            }
            else if let beacon = contact.bodyB.node as? BeaconNode {
                gameSceneDelegate?.didCollide(gameScene: self, plane: firstPlane, beacon: beacon)
            }
        }
        else if let beacon = contact.bodyA.node as? BeaconNode {
            if let plane = contact.bodyB.node as? PlaneNode {
                gameSceneDelegate?.didCollide(gameScene: self, plane: plane, beacon: beacon)
            }
        }
    }
}

// MARK: - Game mechanics
extension GameScene {
    
    private func getRandomBeacon() -> BeaconViewModel? {
        guard beacons.count > 0 else { return nil }
        let randomIndex = Int.random(in: 0..<beacons.count)
        return beacons[randomIndex]
    }

    private func getBeaconPosition(for beaconName: BeaconName) -> CGPoint {
        let minimumX: CGFloat
        let maximumX: CGFloat
        let minimumY: CGFloat
        let maximumY: CGFloat
        
        switch beaconName {
        case .beaconAirport:  // Random location in the bottom middle of the game board
            minimumX = size.width * 0.2
            maximumX = size.width * 0.8
            minimumY = (size.height - navigationBarHeight) * 0.2
            maximumY = (size.height - navigationBarHeight) * 0.5
        case .beaconLeft:     // Random position on the left edge of the game board
            minimumX = BeaconViewModel.width / 5.0
            maximumX = minimumX
            minimumY = BeaconViewModel.height / 2.0
            maximumY = size.height - navigationBarHeight - BeaconViewModel.height / 2.0
        case .beaconRight:    // Random position on the right edge of the game board
            minimumX = size.width - BeaconViewModel.width / 5.0
            maximumX = minimumX
            minimumY = BeaconViewModel.height / 2.0
            maximumY = size.height - navigationBarHeight - BeaconViewModel.height / 2.0
        case .beaconTop:      // Random position on the top edge of the game board
            minimumX = BeaconViewModel.width / 2.0
            maximumX = size.width - BeaconViewModel.width / 2.0
            minimumY = size.height - navigationBarHeight - BeaconViewModel.height / 5.0
            maximumY = minimumY
        case .beaconBottom:   // Random position on the bottom edge of the game board
            minimumX = BeaconViewModel.width / 2.0
            maximumX = size.width - BeaconViewModel.width / 2.0
            minimumY = BeaconViewModel.height / 5.0
            maximumY = minimumY
        }
        
        let xCoord = minimumX == maximumX ? minimumX : CGFloat.random(in: minimumX ... maximumX)
        let yCoord = minimumY == maximumY ? minimumY : CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }

    private func spawnPosition(for beaconNode: BeaconNode, name: BeaconName) -> CGPoint {
        switch name {
        case .beaconAirport:  // To the top of the beacon, on the runway
            return CGPoint(x: beaconNode.position.x, y: beaconNode.position.y + 100.0)
        case .beaconLeft:  // To the right of the beacon
            return CGPoint(x: beaconNode.position.x + BeaconViewModel.width / 2.0 + PlaneViewModel.width / 2.0, y: beaconNode.position.y)
        case .beaconRight:  // To the left of the beacon
            return CGPoint(x: beaconNode.position.x - BeaconViewModel.width / 2.0 - PlaneViewModel.width / 2.0, y: beaconNode.position.y)
        case .beaconTop:  // To the bottom of the beacon
            return CGPoint(x: beaconNode.position.x, y: beaconNode.position.y - BeaconViewModel.height / 2.0 - PlaneViewModel.height / 2.0)
        case .beaconBottom:  // To the top of the beacon
            return CGPoint(x: beaconNode.position.x, y: beaconNode.position.y + BeaconViewModel.height / 2.0 + PlaneViewModel.height / 2.0)
        }
    }

    private func initialPath(for beacon: BeaconViewModel) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: beacon.spawnPosition)
        bezierPath.addLine(to: CGPoint(x: beacon.spawnPosition.x + initialPathDeltaVector(for: beacon.beacon).x, y: beacon.spawnPosition.y + initialPathDeltaVector(for: beacon.beacon).y))
        return bezierPath
    }

    private func initialPathDeltaVector(for beacon: Beacon) -> (x: CGFloat, y: CGFloat) {
        switch beacon.name {
        case .beaconAirport:
            return (0.0, 300.0)   // Move up
        case .beaconLeft:
            return (300.0, 0.0)   // Move right
        case .beaconRight:
            return (-300.0, 0.0)  // Move left
        case .beaconTop:
            return (0.0, -300.0)  // Move down
        case .beaconBottom:
            return (0.0, 300.0)   // Move up
        }
    }
}
