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
        let baseName = BeaconNode.atlasName(for: beaconName)
        let beaconAnimationAtlas = SKTextureAtlas(named: baseName)
        var beaconAnimationFrames = [SKTexture]()
        let numImages = beaconAnimationAtlas.textureNames.count
        for i in 0..<numImages {
            let beaconTextureName = "\(baseName)0\(i)"
            let texture = beaconAnimationAtlas.textureNamed(beaconTextureName)
            beaconAnimationFrames.append(texture)
        }
        
        super.init(texture: beaconAnimationFrames[0], color: .clear, size: beaconAnimationFrames[0].size())
        
        size = CGSize(width: BeaconViewModel.width, height: BeaconViewModel.height)
        self.run(SKAction.repeatForever(SKAction.animate(with: beaconAnimationFrames,
                                                           timePerFrame: 0.4,
                                                           resize: false,
                                                           restore: true)),
                   withKey:"\(baseName)SignalAnimation")
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(texture: beaconAnimationFrames[0], size: size)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.mass = 100000
        physicsBody?.contactTestBitMask = physicsBody?.collisionBitMask ?? 0xFFFFFFFF
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BeaconNode {

    private static func atlasName(for beaconName: BeaconName) -> String {
        switch beaconName {
        case .beaconAirport:
            return "beacon-blue"
        case .beaconLeft:
            return "beacon-orange"
        case .beaconRight:
            return "beacon-cyan"
        case .beaconTop:
            return "beacon-purple"
        case .beaconBottom:
            return "beacon-yellow"
        }
    }
}
