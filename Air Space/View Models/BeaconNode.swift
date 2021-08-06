//
//  BeaconNode.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-08-04.
//

import UIKit
import SpriteKit

class BeaconNode: SKSpriteNode {
    
    // Initializer
    init(beaconName: BeaconName) {
        let beaconAnimationAtlas = SKTextureAtlas(named: "beacon-sprite")
        var beaconAnimationFrames = [SKTexture]()
        let numImages = beaconAnimationAtlas.textureNames.count
        for i in 0..<numImages {
            let beaconTextureName = "beacon0\(i)"
            let texture = beaconAnimationAtlas.textureNamed(beaconTextureName)
            beaconAnimationFrames.append(texture)
        }
        
        super.init(texture: beaconAnimationFrames[0], color: .clear, size: beaconAnimationFrames[0].size())
        
        size = CGSize(width: BeaconViewModel.width, height: BeaconViewModel.height)
        self.run(SKAction.repeatForever(SKAction.animate(with: beaconAnimationFrames,
                                                           timePerFrame: 0.2,
                                                           resize: false,
                                                           restore: true)),
                   withKey:"beaconSignalAnimation")
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(texture: beaconAnimationFrames[0], size: size)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.mass = 100000
        physicsBody?.contactTestBitMask = physicsBody?.collisionBitMask ?? 0xFFFFFFFF
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = beaconName.rawValue
        label.zPosition = 1.0
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
//        label.position = labelPosition(for: beaconName)
        addChild(label)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension BeaconNode {
//
//    private func labelPosition(for beaconName: BeaconName) -> CGPoint {
//        switch beaconName {
//        case .beaconAirport, .beaconLeft, .beaconTop:
//            return CGPoint(x: Beacon, y: <#T##CGFloat#>)
//        case .beaconRight:
//        case .beaconBottom:
//        }
//    }
//}
