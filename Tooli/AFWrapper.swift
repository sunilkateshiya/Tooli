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
     
     class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
        print(params!)
          Alamofire.request(strURL, method: .post, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
               guard responseObject.result.isSuccess else {
                
                failure(NSError())
                return;
                }
            
               
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
