//
//  File.swift
//  Tooli
//
//  Created by Impero IT on 11/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import Foundation

import UIKit
import ObjectMapper

class GetYourConnectionList: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : [ConnectionM] = []
    
    override init()
    {
        
    }
    required init?(map: Map){
        Status <- map["Status"]
        Message <- map["Message"]
        Result <- map["Result"]
        
    }
    func mapping(map: Map) {
        Status <- map["Status"]
        Message <- map["Message"]
        Result <- map["Result"]
    }
}
class ConnectionM: NSObject, Mappable
{
    var UserID = ""
    var Name = ""
    var ProfileImageLink = ""
    var CityName = ""
    var DistanceAwayText = ""
    var Description = ""
    var IsSaved = false
    var IsFollowing = false
    var Role = 0
    var PageType = 0
    var JobRoleName  = ""
    override init()
    {
        
    }
    required init?(map: Map){
        UserID <- map["UserID"]
        PageType <- map["PageType"]
        Name <- map["Name"]
        ProfileImageLink <- map["ProfileImageLink"]
        CityName <- map["CityName"]
        DistanceAwayText <- map["DistanceAwayText"]
        Description <- map["Description"]
        IsSaved <- map["IsSaved"]
        IsFollowing <- map["IsFollowing"]
        Role <- map["Role"]
        JobRoleName <- map["JobRoleName"]
        
    }
    func mapping(map: Map)
    {
        UserID <- map["UserID"]
        PageType <- map["PageType"]
        Name <- map["Name"]
        ProfileImageLink <- map["ProfileImageLink"]
        CityName <- map["CityName"]
        DistanceAwayText <- map["DistanceAwayText"]
        Description <- map["Description"]
        IsSaved <- map["IsSaved"]
        IsFollowing <- map["IsFollowing"]
        Role <- map["Role"]
        JobRoleName <- map["JobRoleName"]
    }
}

