//
//  UserTxnSum.swift
//  FastLive
//
//  Created by Amrit Singh on 9/18/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

class UserTxnSum: NSObject {
    var team:String?
    var teamAmount:Int?

    class func userTxnSum(UserTxnSum:UserTxnSum, data:[String:Any]) -> UserTxnSum
    {
        UserTxnSum.team = data["team"] as? String
        UserTxnSum.teamAmount = data["teamAmount"] as? Int
        return UserTxnSum
    }
}
