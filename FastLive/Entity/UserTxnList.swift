//
//  UserTxnList.swift
//  FastLive
//
//  Created by Amrit Singh on 9/19/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

class UserTxnList: NSObject {

    var betAmount: Int?
    var commission: Int?
    var id: Int?
    var rate: Int?
    var support: String?
    var teamName: String?

    class func userTxnList(UserTxnList:UserTxnList, data:[String:Any]) -> UserTxnList
    {
        UserTxnList.betAmount = data["betAmount"] as? Int
        UserTxnList.commission = data["commission"] as? Int
        UserTxnList.id = data["id"] as? Int
        UserTxnList.rate = data["rate"] as? Int
        UserTxnList.support = data["support"] as? String
        UserTxnList.teamName = data["teamName"] as? String
        return UserTxnList
    }
    
}
