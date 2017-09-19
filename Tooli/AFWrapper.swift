//
//  AFWrapper.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class AFWrapper: NSObject {
     class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
          Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
               
               print(responseObject)
               
               if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
               }
               if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
               }
          }
     }
    class func requestGetUrlWithParam(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        Alamofire.request(strURL, method: .get, parameters: params, headers: header).responseJSON { (responseObject) -> Void in
            print(responseObject)
            guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
            }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    class func requestDeleteUrlWithParam(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        Alamofire.request(strURL, method: .delete, parameters: params, headers: header).responseJSON { (responseObject) -> Void in
            print(responseObject)
            guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
            }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
     class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        print(header)
          Alamofire.request(strURL, method: .post, parameters: params, headers: header).responseJSON { (responseObject) -> Void in
                print(responseObject)
               guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
                }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
               if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
               }
               if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
               }
          }
     }
    
    
    class func requestPOSTURLWithJson(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (responseObject) -> Void in
            debugPrint(responseObject)
            print(responseObject)
            guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
            }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

    class func requestPUTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        print(header)
        Alamofire.request(strURL, method: .put, parameters: params, headers: header).responseJSON { (responseObject) -> Void in
            print(responseObject)
            guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
            }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    class func requestPUTURLWithJson(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        
        Alamofire.request(strURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (responseObject) -> Void in
            debugPrint(responseObject)
            print(responseObject)
            guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
            }
            checkStatusCode(statusCode: (responseObject.response?.statusCode)!)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
func checkStatusCode(statusCode:Int)
{
    if(statusCode == 401)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: Constants.KEYS.LOGINKEY)
        userDefaults.synchronize()
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.disconnectSignalR()
        app.MoveToLoginScreen()
        return
    }
}
