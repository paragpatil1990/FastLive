//
//  Match.swift
//  FastFive
//
//  Created by Amrit Singh on 9/12/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

class Match: NSObject
{
    var colorCode:String?
    var colorId:Int?
    var matchId:Int?
    var matchName:String?
    var matchType:String?
    var matchTypeId:Int?
    
    class func match(match:Match, data:[String:Any]) -> Match
    {
        match.colorCode = data["colorCode"] as? String
        match.colorId = data["colorId"] as? Int
        match.matchId = data["matchId"] as? Int
        match.matchName = data["matchName"] as? String
        match.matchType = data["matchType"] as? String
        match.matchTypeId = data["matchTypeId"] as? Int
        return match
    }

    
}
