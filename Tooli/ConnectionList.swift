//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class ConnectionList: NSObject, Mappable  {
    
    var status = ""
    var message = ""
    var FollowerList : [FollowerModel]?
    var FollowingList : [FollowerModel]?
  
    required init?(map: Map){
        status <- map["status"]
        message <- map["message"]
        FollowerList <- map["FollowerList"]
        FollowingList <- map["FollowingList"]
       
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        FollowerList <- map["FollowerList"]
        FollowingList <- map["FollowingList"]
    }
}



class FollowerModel : NSObject, Mappable{

    
    var PrimaryID = 0
    var IsContractor : Bool = true
    var UserFullName = ""
    var IsSaved : Bool = true
    var ProfileImageLink = ""
    var TradeCategoryName = ""
    var CityName = ""
    var Description = ""
    var CompanyName = ""
    
    
    required init?(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        IsContractor <- map["IsContractor"]
        UserFullName <- map["UserFullName"]
        IsSaved <- map["IsSaved"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        Description <- map["Description"]
        CompanyName <- map["CompanyName"]
        
    }
    func mapping(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        IsContractor <- map["IsContractor"]
        UserFullName <- map["UserFullName"]
        IsSaved <- map["IsSaved"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        Description <- map["Description"]
        CompanyName <- map["CompanyName"]
        
    }
}

