//
//  BeaconViewModel.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-08-04.
//

import UIKit
import SpriteKit

class BeaconViewModel {

    var beacon: Beacon
    var beaconNode: BeaconNode
    var spawnPosition: CGPoint

    static let width: CGFloat = 44.0
    static let height: CGFloat = 44.0

    init(beaconNode: BeaconNode, name: BeaconName, spawnPosition: CGPoint) {
        self.beaconNode = beaconNode
        self.spawnPosition = spawnPosition
        beacon = Beacon(name: name)
    }
}

extension BeaconViewModel : Equatable {
    
    static func == (lhs: BeaconViewModel, rhs: BeaconViewModel) -> Bool {
        return lhs.beacon == rhs.beacon
    }
}
