//
//  Constants.swift
//  MatchpointGPS
//
//  Created by SwapnilP on 25/08/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import Foundation

enum CarStatus:Int{
    case Connection_Lost = 1
    case Moving = 2
    case Idling = 3
    case Parked = 4
}

enum CarType:Int {
    case car = 1
    case bike = 2
    case bus = 3
    case garbage = 4
    case ambulance = 5
    case fire_truck = 6
    case taxi = 7
    case vip = 8
}
 
