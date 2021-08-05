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

    static let width: CGFloat = 44.0
    static let height: CGFloat = 44.0

    init(beaconNode: BeaconNode, name: BeaconName) {
        self.beaconNode = beaconNode
        beacon = Beacon(name: name)
    }
}

extension BeaconViewModel : Equatable {
    
    static func == (lhs: BeaconViewModel, rhs: BeaconViewModel) -> Bool {
        return lhs.beacon == rhs.beacon
    }
}
