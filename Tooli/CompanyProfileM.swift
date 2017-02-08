//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class CompanyProfileM: NSObject, Mappable  {
    
    
    
    var status = ""
    var message = ""
    var UserID = 0
    var PrimaryID = 0
    var PageTypeID = 0
    var ProfileImageLink = ""
    var Name = ""
    var TradeCategoryName = ""
    var CompanyName = ""
    var IsSaved : Bool = false
    var SavePageStarImageLink = ""
    var Description = ""
    var IsFollow : Bool = false
    var EmailID = ""
    var StreetAddress = ""
    var CityName = ""
    var Zipcode = ""
    var ContactNumber = ""
    var FolowText = ""
    var ServiceGroup = ""
    var JobList : [JobListM]? = []
    var OfferList : [OfferListM]? = []
    
    required init?(map: Map){
        status <- map["status"]
        message <- map["message"]
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        CompanyName <- map["CompanyName"]
        TradeCategoryName <- map["TradeCategoryName"]
        IsSaved <- map["IsSaved"]
        CityName <- map["CityName"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Description <- map["Description"]
        IsFollow <- map["IsFollow"]
        StreetAddress <- map["StreetAddress"]
        EmailID <- map["EmailID"]
        ContactNumber <- map["ContactNumber"]
        Zipcode <- map["Zipcode"]
        FolowText <- map["FolowText"]
        ServiceGroup <- map["ServiceGroup"]
        JobList <- map["JobList"]
        OfferList <- map["OfferList"]
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        CompanyName <- map["CompanyName"]
        TradeCategoryName <- map["TradeCategoryName"]
        IsSaved <- map["IsSaved"]
        CityName <- map["CityName"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Description <- map["Description"]
        IsFollow <- map["IsFollow"]
        StreetAddress <- map["StreetAddress"]
        EmailID <- map["EmailID"]
        ContactNumber <- map["ContactNumber"]
        Zipcode <- map["Zipcode"]
        FolowText <- map["FolowText"]
        ServiceGroup <- map["ServiceGroup"]
        JobList <- map["JobList"]
        OfferList <- map["OfferList"]
    }
}



class JobListM : NSObject, Mappable {
    
    var UserID = 0
    var PrimaryID = 0
    var PageTypeID = 0
    var ProfileImageLink = ""
    var SavePageStarImageLink = ""
    var Title = ""
    var Description = ""
    var StartOn = ""
    var EndOn = ""
    var Location = ""
    var CityName = ""
    var TradeCategoryName = ""
    
    required init?(map: Map) {
        
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

class OfferListM : NSObject, Mappable {
    
    
    var UserID = 0
    var PrimaryID = 0
    var PageTypeID = 0
    var ProfileImageLink = ""
    var SavePageStarImageLink = ""
    var OfferImageLink = ""
    var Title = ""
    var Description = ""
    var RedirectLink = ""
    
    required init?(map: Map) {
        
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Title <- map["Title"]
        Description <- map["Description"]
        RedirectLink <- map["RedirectLink"]
        OfferImageLink <- map["OfferImageLink"]
        
    }
    func mapping(map: Map) {
        
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ProfileImageLink <- map["ProfileImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        Title <- map["Title"]
        Description <- map["Description"]
        RedirectLink <- map["RedirectLink"]
        OfferImageLink <- map["OfferImageLink"]
        
    }
}
