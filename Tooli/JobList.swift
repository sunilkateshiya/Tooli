//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class JobList: NSObject, Mappable  {
    
    var status = ""
    var message = ""
    var DataList : [JobCenterM]? = []
  
    required init?(map: Map){
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
       
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
    }
}



class JobCenterM : NSObject, Mappable {
    
   
     var AddedOn = ""
     var DistanceInMiles = 0
     var DistanceText = ""
    var UserID = 0
    var PrimaryID = 0
    var PageTypeID = 0
    var ProfileImageLink = ""
    var SavePageStarImageLink = ""
    var IsSaved = false
    var Title = ""
    var CompanyName = ""
    var Description = ""
    var StartOn = ""
    var EndOn = ""
    var Location = ""
    var CityName = ""
    var TradeCategoryName = ""
    
    required init?(map: Map) {
       
        AddedOn <- map["AddedOn"]
        DistanceInMiles <- map["DistanceInMiles"]
        DistanceText <- map["DistanceText"]
        IsSaved <- map["IsSaved"]
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Title <- map["Title"]
        Description <- map["Description"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        Location <- map["Location"]
        CityName <- map["CityName"]
        TradeCategoryName <- map["TradeCategoryName"]
        
    }
    func mapping(map: Map) {
        
        AddedOn <- map["AddedOn"]
        DistanceInMiles <- map["DistanceInMiles"]
        DistanceText <- map["DistanceText"]
        IsSaved <- map["IsSaved"]
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Title <- map["Title"]
        Description <- map["Description"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        Location <- map["Location"]
        CityName <- map["CityName"]
        TradeCategoryName <- map["TradeCategoryName"]
    }
}
