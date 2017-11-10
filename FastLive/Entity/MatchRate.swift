//
//  MatchRate.swift
//  FastLive
//
//  Created by Amrit Singh on 9/27/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

class MatchRate: NSObject {

    var back: String?
    var backAmt: Int?
    var lay: String?
    var layAmt: Int?
    var matchId: Int!
    var team: String?
    
    override init()
    {
        super.init()
    }
    
    class func matchRate(matchRate:MatchRate, data:[String:Any]) -> MatchRate
    {
        matchRate.back = data["back"] as? String
        matchRate.backAmt = data["backAmt"] as? Int
        matchRate.lay = data["lay"] as? String
        matchRate.layAmt = data["layAmt"] as? Int
        matchRate.matchId = data["matchId"] as? Int
        matchRate.team = data["team"] as? String
        return matchRate
    }

    
}
