//
//  SearchContractoreList.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class SearchContractoreList: NSObject, Mappable
{
    var Status = ""
    var Message = ""
    var DataList : [SerachDashBoardM] = []
    
    override init() {
        
    }
    required init?(map: Map){
        Status <- map["Status"]
        Message <- map["Message"]
        DataList <- map["Result"]
        
    }
    func mapping(map: Map) {
        Status <- map["Status"]
        Message <- map["Message"]
        DataList <- map["Result"]
    }
}

class SerachDashBoardM : NSObject, Mappable

{
    var UserID = ""
    var Name = ""
    var IsMe:Bool = false
    var Role = 0
    
    required override init(){
        
    }
    required init?(map: Map)
    {
         UserID <- map["UserID"]
         Name <- map["Name"]
         IsMe <- map["IsMe"]
         Role <- map["Role"]
    }
    func mapping(map: Map) {
        
        UserID <- map["UserID"]
        Name <- map["Name"]
        IsMe <- map["IsMe"]
        Role <- map["Role"]
    }
}
class GetFilterListConntractorM: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : [ContractorDetailM] = []
    
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
class ContractorDetailM: NSObject, Mappable
{
    var ProfileImageLink = ""
    var Description = ""
    var DistanceInMiles = 0.0
    var CityName = ""
    var UserID = ""
    var IsSaved = false
    var DistanceAwayText = ""
    var JobRoleName = ""
    var FullName = ""
    override init()
    {
        
    }
    required init?(map: Map){
        ProfileImageLink <- map["ProfileImageLink"]
        Description <- map["Description"]
        DistanceInMiles <- map["DistanceInMiles"]
        CityName <- map["CityName"]
        UserID <- map["UserID"]
        IsSaved <- map["IsSaved"]
        DistanceAwayText <- map["DistanceAwayText"]
        JobRoleName <- map["JobRoleName"]
        FullName <- map["FullName"]
        
    }
    func mapping(map: Map)
    {
        ProfileImageLink <- map["ProfileImageLink"]
        Description <- map["Description"]
        DistanceInMiles <- map["DistanceInMiles"]
        CityName <- map["CityName"]
        UserID <- map["UserID"]
        IsSaved <- map["IsSaved"]
        DistanceAwayText <- map["DistanceAwayText"]
        JobRoleName <- map["JobRoleName"]
        FullName <- map["FullName"]
    }
}
