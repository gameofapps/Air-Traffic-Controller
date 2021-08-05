//
//  BeaconNode.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-08-04.
//

import UIKit
import SpriteKit

class BeaconNode: SKSpriteNode {
    
    // Public properties
    static let diameter: CGFloat = 44.0

    // Initializer
    init() {
        let beaconAnimationAtlas = SKTextureAtlas(named: "beacon-sprite")
        var beaconAnimationFrames = [SKTexture]()
        let numImages = beaconAnimationAtlas.textureNames.count
        for i in 0..<numImages {
            let beaconTextureName = "beacon0\(i)"
            let texture = beaconAnimationAtlas.textureNamed(beaconTextureName)
            beaconAnimationFrames.append(texture)
        }
        
        super.init(texture: beaconAnimationFrames[0], color: .clear, size: beaconAnimationFrames[0].size())
        
        size = CGSize(width: BeaconNode.diameter, height: BeaconNode.diameter)
        self.run(SKAction.repeatForever(SKAction.animate(with: beaconAnimationFrames,
                                                           timePerFrame: 0.2,
                                                           resize: false,
                                                           restore: true)),
                   withKey:"beaconSignalAnimation")
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(texture: beaconAnimationFrames[0], size: size)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.mass = 0.1
        physicsBody?.contactTestBitMask = physicsBody?.collisionBitMask ?? 0xFFFFFFFF
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
