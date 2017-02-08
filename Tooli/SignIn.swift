//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class SignIn: NSObject, Mappable  {
    var FirstName = ""
    var LastName = ""
    var PerDayRate = ""

    var status = ""
    var message = ""
    var UserID = 0
    var ContractorID = 0
    var MyReferenceID = ""
    var ProfileImageLink = ""
    var AvailableStatusID = 0
    var AvailableStatusIcon = ""
    var TradeCategoryName = ""
    var TradeCategoryID = 0
    var CityName = ""
    var DOB = ""
    var IsSetupProfile : Bool = false
    var CompanyName = ""
    var LandlineNumber = ""
    var MobileNumber = ""
    var EmailID = ""
    var Aboutme = ""
    var Zipcode = ""
    var DistanceRadius = 0
    var IsLicenceHeld : Bool = false
    var IsOwnVehicle : Bool = false
    var FullAddress = ""
    var Latitude = 0.00
    var Longitude = 0.00
    var StreetAddress = ""
    var PerHourRate = ""
    var IsSaved : Bool = false
    var IsFollow : Bool = false
    var AvailableStatusList : [AvailableStatusListM]? = []
    var CertificateFileList : [CertificateFileListM]? = []
    var ServiceList : [ServiceListM]? = []
    var ExperienceList : [Experiences]? = []
    var PortfolioList : [Portfolio]? = []
 
    required init?(map: Map){
        status <- map["status"]
        message <- map["message"]
        UserID <- map["UserID"]
        ContractorID <- map["ContractorID"]
        MyReferenceID <- map["MyReferenceID"]
        ProfileImageLink <- map["ProfileImageLink"]
        AvailableStatusID <- map["AvailableStatusID"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        TradeCategoryName <- map["TradeCategoryName"]
        TradeCategoryID <- map["TradeCategoryID"]
        CityName <- map["CityName"]
        DOB <- map["DOB"]
        IsSetupProfile <- map["IsSetupProfile"]
        CompanyName <- map["CompanyName"]
        LandlineNumber <- map["LandlineNumber"]
        MobileNumber <- map["MobileNumber"]
        EmailID <- map["EmailID"]
        Aboutme <- map["Aboutme"]
        Zipcode <- map["Zipcode"]
        DistanceRadius <- map["DistanceRadius"]
        IsLicenceHeld <- map["IsLicenceHeld"]
        IsOwnVehicle <- map["IsOwnVehicle"]
        FullAddress <- map["FullAddress"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        StreetAddress <- map["StreetAddress"]
        PerHourRate <- map["PerHourRate"]
        IsSaved <- map["IsSaved"]
        IsFollow <- map["IsFollow"]
        AvailableStatusList <- map["AvailableStatusList"]
        ServiceList <- map["ServiceList"]
        ExperienceList <- map["ExperienceList"]
        PortfolioList <- map["PortfolioList"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        PerDayRate <- map["PerDayRate"]
        CertificateFileList <- map["CertificateFileList"]
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        UserID <- map["UserID"]
        ContractorID <- map["ContractorID"]
        MyReferenceID <- map["MyReferenceID"]
        ProfileImageLink <- map["ProfileImageLink"]
        AvailableStatusID <- map["AvailableStatusID"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        TradeCategoryName <- map["TradeCategoryName"]
        TradeCategoryID <- map["TradeCategoryID"]
        CityName <- map["CityName"]
        DOB <- map["DOB"]
        IsSetupProfile <- map["IsSetupProfile"]
        CompanyName <- map["CompanyName"]
        LandlineNumber <- map["LandlineNumber"]
        MobileNumber <- map["MobileNumber"]
        EmailID <- map["EmailID"]
        Aboutme <- map["Aboutme"]
        Zipcode <- map["Zipcode"]
        DistanceRadius <- map["DistanceRadius"]
        IsLicenceHeld <- map["IsLicenceHeld"]
        IsOwnVehicle <- map["IsOwnVehicle"]
        FullAddress <- map["FullAddress"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        StreetAddress <- map["StreetAddress"]
        PerHourRate <- map["PerHourRate"]
        IsSaved <- map["IsSaved"]
        IsFollow <- map["IsFollow"]
        AvailableStatusList <- map["AvailableStatusList"]
        ServiceList <- map["ServiceList"]
        ExperienceList <- map["ExperienceList"]
        PortfolioList <- map["PortfolioList"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        PerDayRate <- map["PerDayRate"]
        CertificateFileList <- map["CertificateFileList"]
    }
}

class Masters : NSObject, Mappable {
    var status = 0
    var message = ""
    var DataList : [Trades]? = []
    required init?(map: Map) {
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

class Trades : NSObject, Mappable {
    var PrimaryID = 0
    var TradeCategoryName = ""
    var ServiceList : [ServiceListM]? = []
    var CertificateCategoryList : [CertificateCategoryList]? = []
    required init?(map: Map) {
        PrimaryID <- map["PrimaryID"]
        TradeCategoryName <- map["TradeCategoryName"]
        ServiceList <- map["ServiceList"]
        CertificateCategoryList <- map["CertificateCategoryList"]
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        TradeCategoryName <- map["TradeCategoryName"]
        ServiceList <- map["ServiceList"]
        CertificateCategoryList <- map["CertificateCategoryList"]
    }
}

class CertificateCategoryList : NSObject, Mappable {
    var PrimaryID = 0
    var CertificateCategoryID = 0
    var CertificateCategoryName = ""
    required override init(){
        
    }
    required init?(map: Map) {
       PrimaryID <- map["PrimaryID"]
       CertificateCategoryName <- map["CertificateCategoryName"]
       CertificateCategoryID <- map["CertificateCategoryID"]
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        CertificateCategoryID <- map["CertificateCategoryID"]
    }
}

class AvailableStatusListM : NSObject, Mappable {
    
    var PrimaryID = 0
    var AvailableStatusName = ""
    var AvailableStatusIcon = ""
    required init?(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        AvailableStatusName <- map["AvailableStatusName"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        AvailableStatusName <- map["AvailableStatusName"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        
    }
}


class ServiceListM : NSObject, Mappable {
    
    
    var ServiceID = 0
    var ServiceName = ""
    required init?(map: Map) {
        
        ServiceID <- map["ServiceID"]
        ServiceName <- map["ServiceName"]
        
    }
    func mapping(map: Map) {
        ServiceID <- map["ServiceID"]
        ServiceName <- map["ServiceName"]
        
    }
}


class ExperienceListM : NSObject, Mappable {
    
    
    var PrimaryID = 0
    var CertificateCategoryName = ""
    
    required init?(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        
    }
}

class Portfolio : NSObject, Mappable {
    var UserID = 0;
    var PrimaryID = 0;
    var PageTypeID = 0;
    var UserFullName = "";
    var ProfileImageLink = "";
    var Date = ""
    var Time = ""
    var Description = ""
    var Location = ""
    var CustomerName = ""
    var Title = ""
    var ThumbnailImageLink = ""
    var SavePageStarImageLink = ""
    var PortfolioImageList : [PortfolioImages] = []
    var TotalPortfolio = 1
    var Caption = ""
    override init() {
        
    }
    required init?(map: Map) {
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        UserFullName <- map["UserFullName"]
        ProfileImageLink <- map["ProfileImageLink"]
        Date <- map["Date"]
        Time <- map["Time"]
        Description <- map["Description"]
        Location <- map["Location"]
        CustomerName <- map["CustomerName"]
        Title <- map["Title"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        PortfolioImageList <- map["PortfolioImageList"]
        TotalPortfolio <- map["TotalPortfolio"]
        Caption <- map["Caption"]
        
    }
    func mapping(map: Map) {
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        UserFullName <- map["UserFullName"]
        ProfileImageLink <- map["ProfileImageLink"]
        Date <- map["Date"]
        Time <- map["Time"]
        Description <- map["Description"]
        Location <- map["Location"]
        CustomerName <- map["CustomerName"]
        Title <- map["Title"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        PortfolioImageList <- map["PortfolioImageList"]
        TotalPortfolio <- map["TotalPortfolio"]
        Caption <- map["Caption"]
    }
}

class PortfolioImages : NSObject, Mappable {
    var PrimaryID = 0
    var PortfolioImageLink = ""
    var img : UIImage?
    var imgName = ""
    var isCreatedbyMe = false;
    override init() {
        
    }
    required init?(map: Map) {
        PrimaryID <- map["PrimaryID"]
        PortfolioImageLink <- map["PortfolioImageLink"]
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        PortfolioImageLink <- map["PortfolioImageLink"]
        
    }
}
class CertificateFileListM : NSObject, Mappable {
    var PrimaryID = 0
    var CertificateCategoryID = 0
    var CertificateCategoryName = ""
    var IshaveFile : Bool = false
    var IsImage : Bool = false
    var FileLink = ""
    var IsPDF : Bool = false
    
    override init() {
        
    }
    
    required init?(map: Map) {
        CertificateCategoryID <- map["CertificateCategoryID"]
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        IsPDF <- map["IsPDF"]
        
    }
    func mapping(map: Map) {
        CertificateCategoryID <- map["CertificateCategoryID"]
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        IsPDF <- map["IsPDF"]
    }
}

class TotalExperience : NSObject, Mappable {
    var ExperienceList : [Experiences] = []
    required override init(){
        
    }
    required init?(map : Map) {
        ExperienceList <- map["ExperienceList"]
    }
    func mapping(map: Map) {
        ExperienceList <- map["ExperienceList"]
    }
}

class Experiences : NSObject, Mappable {
    
    var Title = ""
    var CompanyName = ""
    var ExperienceYear = ""
    required override init(){
        
    }
    required init?(map : Map) {
        Title <- map["Title"]
        CompanyName <- map["CompanyName"]
        ExperienceYear <- map["ExperienceYear"]
    }
    func mapping(map: Map) {
        Title <- map["Title"]
        CompanyName <- map["CompanyName"]
        ExperienceYear <- map["ExperienceYear"]
    }
}

class AppNotificationsList: NSObject, Mappable {
    var status = "0"
    var message = ""
    var DataList : [NotificationDetail] = []
    
    required override init(){
        
    }
    required init?(map : Map) {
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

class NotificationDetail: NSObject, Mappable {
    var TransactionID = 0
    var NotificationStatusID = 0
    var PrimaryID = 0
    var IsContractor = false
    var CompanyID = 0
    var ContractorID = 0
    var ProfileImageLink = ""
    var UserProfileLink = ""
    var FullName = ""
    var NotificationText = ""
    var AddedOn = ""
    var IsRead = false
    var JobTitle = ""
    var RedirectLink = ""
    required override init(){
        
    }
    required init?(map : Map) {
        
    }
    func mapping(map: Map) {
        TransactionID <- map["TransactionID"]
        NotificationStatusID <- map["NotificationStatusID"]
        PrimaryID <- map["PrimaryID"]
        CompanyID <- map["CompanyID"]
        IsContractor <- map["IsContractor"]
        ContractorID <- map["ContractorID"]
        ProfileImageLink <- map["ProfileImageLink"]
        UserProfileLink <- map["UserProfileLink"]
        FullName <- map["FullName"]
        NotificationText <- map["NotificationText"]
        AddedOn <- map["AddedOn"]
        IsRead <- map["IsRead"]
        JobTitle <- map["JobTitle"]
        RedirectLink <- map["RedirectLink"]
    }
    
}
