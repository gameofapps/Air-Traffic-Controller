//
//  Beacon.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-07.
//

import UIKit

struct Beacon {
    
    let name: BeaconName
    let position: CGPoint

    init (name: BeaconName, position: CGPoint) {
        self.name = name
        self.position = position
    }
}

enum BeaconName {
    case beaconA
    case beaconB
    case beaconC
    case beaconD
    case beaconE
}
