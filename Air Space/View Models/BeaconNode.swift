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
    var isOnAlert: Bool = false {
        didSet {
            removeAllActions()
            let animationFrames = isOnAlert ? beaconAlertAnimationFrames : beaconAnimationFrames
            let key = isOnAlert ? "\(baseName)SignalAnimation" : "\(baseName)-alertSignalAnimation"
            run(SKAction.repeatForever(SKAction.animate(with: animationFrames,
                                                        timePerFrame: 0.4,
                                                        resize: false,
                                                        restore: true)),
                                       withKey:key)
        }
    }

    // Initializer
    init(beaconName: BeaconName) {
        baseName = BeaconNode.atlasName(for: beaconName)
        let beaconAnimationAtlas = SKTextureAtlas(named: baseName)
        let beaconAlertAnimationAtlas = SKTextureAtlas(named: "\(baseName)-alert")
        let numImages = beaconAnimationAtlas.textureNames.count
        for i in 0..<numImages {
            let beaconTextureName = "\(baseName)0\(i)"
            let beaconTexture = beaconAnimationAtlas.textureNamed(beaconTextureName)
            beaconAnimationFrames.append(beaconTexture)
            let beaconAlertTextureName = "\(baseName)0\(i)-alert"
            let beaconAlertTexture = beaconAlertAnimationAtlas.textureNamed(beaconAlertTextureName)
            beaconAlertAnimationFrames.append(beaconAlertTexture)
        }
        
        super.init(texture: beaconAnimationFrames[0], color: .clear, size: beaconAnimationFrames[0].size())
        
        isUserInteractionEnabled = true
        size = CGSize(width: BeaconViewModel.width, height: BeaconViewModel.height)
        physicsBody = SKPhysicsBody(texture: beaconAnimationFrames[0], size: size)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.mass = 100000
        physicsBody?.contactTestBitMask = physicsBody?.collisionBitMask ?? 0xFFFFFFFF
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Private properties
    let baseName: String
    var beaconAnimationFrames = [SKTexture]()
    var beaconAlertAnimationFrames = [SKTexture]()
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
