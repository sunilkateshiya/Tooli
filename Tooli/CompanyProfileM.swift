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
    var IsSaved = false
    var ServiceList:[ServiceListListM]? = []
    
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
        IsSaved <- map["IsSaved"]
        ServiceList <- map["ServiceList"]
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
        IsSaved <- map["IsSaved"]
        ServiceList <- map["ServiceList"]
    }
}
class ServiceListListM:NSObject,Mappable
{
    var  Service = ""
    
    required init?(map: Map)
    {
      Service <- map["ServiceName"]
    }
    func mapping(map: Map)
    {
       Service <- map["ServiceName"]
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
    var AddedOn = ""
    var PriceTag = ""
    var IsSaved = false
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
        AddedOn <- map["AddedOn"]
        PriceTag <- map["PriceTag"]
        IsSaved <- map["IsSaved"]
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
        AddedOn <- map["AddedOn"]
        PriceTag <- map["PriceTag"]
        IsSaved <- map["IsSaved"]
    }
}
class OfferDetailM : NSObject, Mappable {
    
    
    var CompanyID = 0
    var IsSaved = false
    var IsCompanySaved = false
    var CompanyImageLink = ""
    var CompanyName = ""
    var CompanyTradeCategoryName = ""
    var CompanyCityName = ""
    var Title = ""
    var Description = ""
    var DistanceRadius = ""
    var EmailID = ""
    var RedirectLink = ""
    var Zipcode = ""
    var PriceTag = ""
    var IsFollow = false
    var AddedOn = ""
    
    required init?(map: Map) {
        
        CompanyID <- map["CompanyID"]
        IsSaved <- map["IsSaved"]
        IsCompanySaved <- map["IsCompanySaved"]
        CompanyImageLink <- map["CompanyImageLink"]
        CompanyName <- map["CompanyName"]
        CompanyTradeCategoryName <- map["CompanyTradeCategoryName"]
        CompanyCityName <- map["CompanyCityName"]
        Title <- map["Title"]
        Description <- map["Description"]
        DistanceRadius <- map["DistanceRadius"]
        EmailID <- map["EmailID"]
        RedirectLink <- map["RedirectLink"]
        Zipcode <- map["Zipcode"]
        PriceTag <- map["PriceTag"]
        IsFollow <- map["IsFollow"]
        AddedOn <- map["AddedOn"]
    }
    func mapping(map: Map) {
        
        CompanyID <- map["CompanyID"]
        IsSaved <- map["IsSaved"]
        IsCompanySaved <- map["IsCompanySaved"]
        CompanyImageLink <- map["CompanyImageLink"]
        CompanyName <- map["CompanyName"]
        CompanyTradeCategoryName <- map["CompanyTradeCategoryName"]
        CompanyCityName <- map["CompanyCityName"]
        Title <- map["Title"]
        Description <- map["Description"]
        DistanceRadius <- map["DistanceRadius"]
        EmailID <- map["EmailID"]
        RedirectLink <- map["RedirectLink"]
        Zipcode <- map["Zipcode"]
        PriceTag <- map["PriceTag"]
        IsFollow <- map["IsFollow"]
        AddedOn <- map["AddedOn"]
    }
}
/*

 "EmailID": "Sales@jelelectrical.co.uk",
 "PriceTag": "£5",
 "RedirectLink": "https://ak0.scstatic.net/1/cdn2-cont3.sweetcouch.com/2979682-fenix-tk75-led-searchlight-powerful-flashlight.jpg",
 "Zipcode": "",
 "IsFollow": true
 */
