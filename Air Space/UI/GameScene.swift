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

    // Public methods
    func spawnNewPlane() -> PlaneViewModel? {
        guard let originBeacon = getRandomBeacon(), let destinationBeacon = getRandomBeacon() else { return nil }

        let planeNode = PlaneNode()
        planeNode.position = originBeacon.spawnPosition
        addChild(planeNode)

        let planeViewModel = PlaneViewModel(planeNode: planeNode, origin: originBeacon.beacon.name, destination: destinationBeacon.beacon.name)
        planes.append(planeViewModel)

        planeNode.setMotion(on: initialPath(for: originBeacon), transform: false)

        return planeViewModel
    }
    
    func setupBoard() {
        let leftBeaconNode = BeaconNode()
        leftBeaconNode.position = getBeaconLeftPosition()
        addChild(leftBeaconNode)
        let leftBeaconViewModel = BeaconViewModel(beaconNode: leftBeaconNode, name: .beaconA, spawnPosition: spawnPosition(for: leftBeaconNode, name: .beaconA))
        beacons.append(leftBeaconViewModel)

        let rightBeaconNode = BeaconNode()
        rightBeaconNode.position = getBeaconRightPosition()
        addChild(rightBeaconNode)
        let rightBeaconViewModel = BeaconViewModel(beaconNode: rightBeaconNode, name: .beaconB, spawnPosition: spawnPosition(for: rightBeaconNode, name: .beaconB))
        beacons.append(rightBeaconViewModel)
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

    private func getBeaconLeftPosition() -> CGPoint {
        let xCoord: CGFloat = BeaconViewModel.width / 10.0
        let minimumY: CGFloat = BeaconViewModel.height / 2.0
        let maximumY: CGFloat = size.height - 96.0 - BeaconViewModel.height / 2.0
        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }

    private func getBeaconRightPosition() -> CGPoint {
        let xCoord: CGFloat = size.width - BeaconViewModel.width / 10.0
        let minimumY: CGFloat = BeaconViewModel.height / 2.0
        let maximumY: CGFloat = size.height - 96.0 - BeaconViewModel.height / 2.0
        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }

    private func spawnPosition(for beaconNode: BeaconNode, name: BeaconName) -> CGPoint {
        switch name {
        case .beaconA:
            return CGPoint(x: beaconNode.position.x + BeaconViewModel.width / 2.0 + PlaneViewModel.width / 2.0, y: beaconNode.position.y)
        case .beaconB:
            return CGPoint(x: beaconNode.position.x - BeaconViewModel.width / 2.0 - PlaneViewModel.width / 2.0, y: beaconNode.position.y)
        default:
            return CGPoint.zero
        }
    }

    private func initialPath(for beacon: BeaconViewModel) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: beacon.spawnPosition)
        bezierPath.addLine(to: CGPoint(x: beacon.spawnPosition.x + deltaVector(for: beacon.beacon).x, y: beacon.spawnPosition.y + deltaVector(for: beacon.beacon).y))
        return bezierPath
    }

    private func deltaVector(for beacon: Beacon) -> (x: CGFloat, y: CGFloat) {
        switch beacon.name {
        case .beaconA:
            return (100.0, 0.0)
        case .beaconB:
            return (-100.0, 0.0)
        case .beaconC:
            return (0.0, 100.0)
        default:
            return (0.0, 0.0)
        }
    }
}
