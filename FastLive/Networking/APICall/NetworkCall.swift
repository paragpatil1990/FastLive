//
//  NetworkCall.swift
//  MatchpointGPS
//
//  Created by Amrit Singh on 8/17/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import UIKit
import Alamofire

// Here we do all network related work.
class NetworkCall: NSObject
{
    //static let sharedInstance = NetworkCall()
    static let BaseURL: String = "http://109.169.53.35:8080/webservice/" //"http://5.77.55.254:8080/webservice/"
    static let app_version: String = "2.0"
    var is_success:Bool!
    var data: Any!
    var response_message:String!
    var headers: HTTPHeaders = [:]
    
    func apicall(api:String, method:HTTPMethod, parameters: [String: Any], isHud:Bool, completion: @escaping (Any) -> Void)
    {
        let urlStr = String(format: "%@%@", NetworkCall.BaseURL,api)
        
        print("UrlStr = \(urlStr)")
        let presentWindow = UIApplication.shared.windows.first
        if isHud
        {
            presentWindow?.makeToastActivity(message: "Loading...")
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
              
        headers["Content-Type"] = "application/json"
        
        Alamofire.request(urlStr, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                presentWindow?.hideToastActivity()
                switch response.result
                {
                case .success(let JSON):
                    if JSON is [Any]
                    {
                        print("Respoane type as Array [Any] => \(JSON)")
                        presentWindow?.makeToast(message: "Invalid respoane")
                        let responseArray = JSON as! [Any]
                        completion(responseArray)
                    }
                    else if JSON is [String: Any]
                    {
                        print("Respoane type as Dictonary [String: Any] => \(JSON)")
                        var responseDic = JSON as! [String:Any]
                        responseDic = removedNull(dict: responseDic)
                        print(responseDic)
                        
                        let value:String = responseDic["responseCode"] as! String
                        let trueOrFalse = NSString(string: value ).boolValue
                        self.is_success = trueOrFalse
                        
                        
                        print(responseDic["responseCode"]!)
                        self.data = responseDic["responseObject"]
                        self.response_message = responseDic["responseMessage"] as? String
                        completion(responseDic)
                    }
                    else if JSON is String
                    {
                        print("Respoane type as String => \(JSON)")
                        presentWindow?.makeToast(message: "Invalid respoane")
                        let responseString = JSON as! String
                        completion(responseString)
                    }
                    else
                    {
                        print("Respoane type as unknown => \(JSON)")
                        presentWindow?.makeToast(message: "Invalid respoane")
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    presentWindow?.makeToast(message: "\(error.localizedDescription)", duration: 3.0, position: presentWindow?.center as AnyObject)
                    break
                }
        }
        
        
//        Alamofire.request(urlStr, method: .post, parameters: jsons).responseJSON { response in
//            
//            let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//
//            print("RESPONSE \(String(describing: datastring))")
//            
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            presentWindow?.hideToastActivity()
//            switch response.result
//            {
//            case .success(let JSON):
//                if JSON is [Any]
//                {
//                    print("Respoane type as Array [Any]")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                    let responseArray = JSON as! [Any]
//                    completion(responseArray)
//                }
//                else if JSON is [String: Any]
//                {
//                    print("Respoane type as Dictonary [String: Any]")
//                    var responseDic = JSON as! [String:Any]
//                    responseDic = removedNull(dict: responseDic)
//                    print(responseDic)
//                    self.is_success = responseDic["is_success"] as? Bool
//                    self.data = responseDic["data"]
//                    self.response_message = responseDic["response_message"] as? String
//                    completion(responseDic)
//                }
//                else if JSON is String
//                {
//                    print("Respoane type as String")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                    let responseString = JSON as! String
//                    completion(responseString)
//                }
//                else
//                {
//                    print("Respoane type as unknown")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                }
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//                presentWindow?.makeToast(message: "\(error.localizedDescription)", duration: 3.0, position: presentWindow?.center as AnyObject)
//                break
//            }
//        }
    }
    
//    func apicall(api:String, parameters: [String: Any], isHud:Bool, completion: @escaping (Any) -> Void)
//    {
//        let parameters = parameters
//        
//        let urlStr = String(format: "%@%@", APICall.BaseURL,api)
//        
//        print("UrlStr = \(urlStr)")
//        let presentWindow = UIApplication.shared.windows.first
//        if isHud
//        {
//            presentWindow?.makeToastActivity(message: "Loading...")
//        }
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        
//        Alamofire.request(urlStr, method: .post, parameters: parameters).responseJSON { response in
//             print("RESPONSE \(response)")
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            presentWindow?.hideToastActivity()
//            switch response.result
//            {
//            case .success(let JSON):
//                if JSON is [Any]
//                {
//                    print("Respoane type as Array [Any]")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                    let responseArray = JSON as! [Any]
//                    completion(responseArray)
//                }
//                else if JSON is [String: Any]
//                {
//                    print("Respoane type as Dictonary [String: Any]")
//                    var responseDic = JSON as! [String:Any]
//                    responseDic = removedNull(dict: responseDic)
//                    print(responseDic)
//                    self.is_success = responseDic["is_success"] as? Bool
//                    self.data = responseDic["data"]
//                    self.response_message = responseDic["response_message"] as? String
//                    completion(responseDic)
//                }
//                else if JSON is String
//                {
//                    print("Respoane type as String")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                    let responseString = JSON as! String
//                    completion(responseString)
//                }
//                else
//                {
//                    print("Respoane type as unknown")
//                    presentWindow?.makeToast(message: "Invalid respoane")
//                }
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//                presentWindow?.makeToast(message: "\(error.localizedDescription)", duration: 3.0, position: presentWindow?.center as AnyObject)
//                break
//            }
//        }
//    }

}
