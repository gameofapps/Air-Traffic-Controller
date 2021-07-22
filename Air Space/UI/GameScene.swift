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
        return planeViewModel
    }
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
        for node in children {
            if let planeNode = node as? PlaneNode {
                planeNode.updateFreeFlightIfNeeded()
            }
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
        let minimumY = 0.0 + PlaneViewModel.height / 2.0
        let maximumY = size.height - PlaneViewModel.height / 2.0
//        print("minimumY: \(minimumY), maximumY: \(maximumY)")
        let yCoord = CGFloat.random(in: minimumY ... maximumY)
        let position = CGPoint(x: xCoord, y: yCoord)
//        print("xCoord: \(xCoord), yCoord: \(yCoord)")
        return position
    }
}
