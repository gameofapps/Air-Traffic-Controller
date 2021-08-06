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

enum BeaconName : String {
    case beaconAirport = "A"
    case beaconLeft = "L"
    case beaconRight = "R"
    case beaconTop = "T"
    case beaconBottom = "B"
}
