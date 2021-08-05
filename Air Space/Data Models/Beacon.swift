//
//  Beacon.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-07.
//

import UIKit

struct Beacon : Equatable {
    
    let name: BeaconName

    init (name: BeaconName) {
        self.name = name
    }
}

enum BeaconName {
    case beaconA
    case beaconB
    case beaconC
    case beaconD
    case beaconE
}
