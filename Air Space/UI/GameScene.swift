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
    func spawnNewPlane() -> PlaneViewModel {
        let planeNode = PlaneNode()
        planeNode.position = getRandomPlaneStartPosition()
        addChild(planeNode)
        let planeViewModel = PlaneViewModel(planeNode: planeNode)
        planes.append(planeViewModel)
        return planeViewModel
    }
    
    func setupBoard() {
        let leftBeaconNode = BeaconNode()
        leftBeaconNode.position = getBeaconLeftPosition()
        addChild(leftBeaconNode)
        let leftBeaconViewModel = BeaconViewModel(beaconNode: leftBeaconNode, name: .beaconA)
        beacons.append(leftBeaconViewModel)

        let rightBeaconNode = BeaconNode()
        rightBeaconNode.position = getBeaconRightPosition()
        addChild(rightBeaconNode)
        let rightBeaconViewModel = BeaconViewModel(beaconNode: rightBeaconNode, name: .beaconB)
        beacons.append(rightBeaconViewModel)
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
    
    private func getRandomPlaneStartPosition() -> CGPoint {
        let minimumX = 0.0 + PlaneViewModel.width / 2.0
        let maximumX = size.width - PlaneViewModel.width / 2.0
//        print("minimumX: \(minimumX), maximumX: \(maximumX)")
        let xCoord = CGFloat.random(in: minimumX ... maximumX)
        let minimumY = PlaneViewModel.height / 2.0
        let maximumY = size.height - 64.0 - PlaneViewModel.height / 2.0
//        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
//        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }

    private func getBeaconLeftPosition() -> CGPoint {
        let xCoord: CGFloat = BeaconViewModel.width / 10.0
        let minimumY: CGFloat = BeaconViewModel.height / 2.0
        let maximumY: CGFloat = size.height - 64.0 - BeaconViewModel.height / 2.0
        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }

    private func getBeaconRightPosition() -> CGPoint {
        let xCoord: CGFloat = size.width - BeaconViewModel.width / 10.0
        let minimumY: CGFloat = BeaconViewModel.height / 2.0
        let maximumY: CGFloat = size.height - 64.0 - BeaconViewModel.height / 2.0
        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }
}
