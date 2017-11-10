//
//  APICall.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct APICall
{
    static let BaseURL: String = "http://app-beta01.do-sg.mpgps.aspade.in/"
}

extension APICall
{
    static func apicall(api:String, parameters: [String: Any], completion: @escaping (Any) -> Void)
    {
        let parameters = parameters
        
        let urlStr = String(format: "%@%@", APICall.BaseURL,api)
        
        print("UrlStr = \(urlStr)")
        var presentWindow = UIApplication.shared.windows.first
        presentWindow?.makeToastActivity(message: "Loading...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(urlStr, method: .get, parameters: parameters).responseJSON { response in
            // print("RESPONSE \(response)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            presentWindow?.hideToastActivity()
            presentWindow = nil
            switch response.result
            {
            case .success(let JSON):
                if JSON is [Any]
                {
                    let responseArray = JSON as! [Any]
                    completion(responseArray)
                }
                else if JSON is [String: Any]
                {
                    print("user_data is type [String: Any]")
                    var responseDic = JSON as! [String:Any]
                    responseDic = removedNull(dict: responseDic)
                    completion(responseDic)
                }
                else if JSON is String
                {
                    print("user_data is type String")
                }
                else
                {
                    print("user_data is unknown type")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                presentWindow?.makeToast(message: "\(error.localizedDescription)", duration: 3.0, position: presentWindow?.center as AnyObject)
                //                completion(["error":error.localizedDescription])
                break
            }
        }
    }
}

func removedNull(dict:[String:Any]) -> [String:Any]
{
    var dict = dict
    let keys = dict.keys
    for key in keys
    {
        if dict[key] is NSNull
        {
            dict[key] = " "
        }
    }
    return dict
}

func removeNullsFromDictionary(origin:[String:AnyObject]) -> [String:AnyObject]
{
    var destination:[String:AnyObject] = [:]
    for key in origin.keys {
        if origin[key] != nil && !(origin[key] is NSNull){
            if origin[key] is [String:AnyObject] {
                destination[key] = removeNullsFromDictionary(origin: origin[key] as! [String:AnyObject]) as AnyObject?
            } else if origin[key] is [AnyObject] {
                let orgArray = origin[key] as! [AnyObject]
                var destArray: [AnyObject] = []
                for item in orgArray {
                    if item is [String:AnyObject] {
                        destArray.append(removeNullsFromDictionary(origin: item as! [String:AnyObject]) as AnyObject)
                    } else {
                        destArray.append(item)
                    }
                }
            } else {
                destination[key] = origin[key]
            }
        } else {
            destination[key] = "" as AnyObject?
        }
    }
    return destination
}


extension Dictionary
{
    /// An immutable version of update. Returns a new dictionary containing self's values and the key/value passed in.
    
    var reduceNulls: [Key: Value] {
        let tup = filter { !($0.1 is NSNull) }
        return tup.reduce([Key: Value]()) { $0.0.updatedValue($0.1.value, forKey: $0.1.key) }
    }
    
    
    func updatedValue(_ value: Value, forKey key: Key) -> Dictionary<Key, Value> {
        var result = self
        result[key] = value
        return result
    }
}
