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
    var DistanceRadius = ""
    var IsLicenceHeld : Bool = false
    var IsOwnVehicle : Bool = false
    var FullAddress = ""
    var Latitude = 0
    var Longitude = 0
    var StreetAddress = ""
    var PerHourRate = ""
    var IsSaved : Bool = false
    var IsFollow : Bool = false
    var AvailableStatusList : [AvailableStatusListM]? = []
    var CertificateFileList : [CertificateFileListM]? = []
    var ServiceList : [ServiceListM]? = []
    var ExperienceList : [ExperienceListM]? = []
    var PortfolioList : [ExperienceListM]? = []
 
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
    
    
    var CompanyName = ""
    var ExperienceYear = ""
    var Title = ""
    
    required init?(map: Map) {
        
        CompanyName <- map["CompanyName"]
        ExperienceYear <- map["ExperienceYear"]
        Title <- map["Title"]
        
    }
    func mapping(map: Map) {
        CompanyName <- map["CompanyName"]
        ExperienceYear <- map["ExperienceYear"]
        Title <- map["Title"]
        
    }
}


class CertificateFileListM : NSObject, Mappable {
    
    
    var PrimaryID = 0
    var CertificateCategoryName = ""
    var IshaveFile : Bool = false
    var IsImage : Bool = false
    var FileLink = ""
    
    required init?(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        
    }
    func mapping(map: Map) {
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        
    }
}
