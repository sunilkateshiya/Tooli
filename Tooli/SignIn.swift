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
    var IsFollowing : Bool = false
    var ReferralLink = ""
    var AvailableStatusList : [AvailableStatusListM]? = []
    var CertificateFileList : [CertificateFileListM]? = []
    var ServiceList : [ServiceListM]? = []
    var ExperienceList : [Experiences]? = []
    var PortfolioList : [Portfolio]? = []
    var FollowerList :[Follower]? = []
    var FollowingList : [ Following]? = []
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
        IsFollowing <- map["IsFollowing"]
        AvailableStatusList <- map["AvailableStatusList"]
        ServiceList <- map["ServiceList"]
        ExperienceList <- map["ExperienceList"]
        PortfolioList <- map["PortfolioList"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        PerDayRate <- map["PerDayRate"]
        CertificateFileList <- map["CertificateFileList"]
        ReferralLink <- map["ReferralLink"]
        FollowingList <- map["IFollowingList"]
        FollowerList <- map["MyFollowerList"]
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
        IsFollowing <- map["IsFollowing"]
        AvailableStatusList <- map["AvailableStatusList"]
        ServiceList <- map["ServiceList"]
        ExperienceList <- map["ExperienceList"]
        PortfolioList <- map["PortfolioList"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        PerDayRate <- map["PerDayRate"]
        CertificateFileList <- map["CertificateFileList"]
        ReferralLink <- map["ReferralLink"]
        FollowingList <- map["IFollowingList"]
        FollowerList <- map["MyFollowerList"]
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
    var ContractorID = 0
    var PageTypeID = 0;
    var UserFullName = "";
    var ProfileImageLink = "";
    var Date = ""
    var Time = ""
    var Description = ""
    var Location = ""
    var DateTimeCaption = ""
    var CustomerName = ""
    var Title = ""
    var ThumbnailImageLink = ""
    var SavePageStarImageLink = ""
    var PortfolioImageList : [PortfolioImages] = []
    var TotalPortfolio = 1
    var Caption = ""
    var IsSaved : Bool = false
    override init() {
        
    }
    required init?(map: Map) {
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        ContractorID <- map["ContractorID"]
        UserFullName <- map["UserFullName"]
        ProfileImageLink <- map["ProfileImageLink"]
        Date <- map["Date"]
        Time <- map["Time"]
        Description <- map["Description"]
         DateTimeCaption <- map["DateTimeCaption"]
        Location <- map["Location"]
        CustomerName <- map["CustomerName"]
        Title <- map["Title"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        PortfolioImageList <- map["PortfolioImageList"]
        TotalPortfolio <- map["TotalPortfolio"]
        Caption <- map["Caption"]
        IsSaved <- map["IsSaved"]
    }
    func mapping(map: Map) {
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        UserFullName <- map["UserFullName"]
        ContractorID <- map["ContractorID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Date <- map["Date"]
        Time <- map["Time"]
         DateTimeCaption <- map["DateTimeCaption"]
        Description <- map["Description"]
        Location <- map["Location"]
        CustomerName <- map["CustomerName"]
        Title <- map["Title"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        PortfolioImageList <- map["PortfolioImageList"]
        TotalPortfolio <- map["TotalPortfolio"]
        Caption <- map["Caption"]
        IsSaved <- map["IsSaved"]
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
    
    override init() {
        
    }
    
    required init?(map: Map) {
        CertificateCategoryID <- map["CertificateCategoryID"]
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        IsImage <- map["IsImage"]
        
    }
    func mapping(map: Map) {
        CertificateCategoryID <- map["CertificateCategoryID"]
        PrimaryID <- map["PrimaryID"]
        CertificateCategoryName <- map["CertificateCategoryName"]
        IshaveFile <- map["IshaveFile"]
        IsImage <- map["IsImage"]
        FileLink <- map["FileLink"]
        IsImage <- map["IsImage"]
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
    var DateTimeCaption = ""
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
        DateTimeCaption <- map["DateTimeCaption"]
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
class StatisticsModal:NSObject,Mappable
{
    var TotalProfileView = 0
    var TotalProfileSave = 0
    var TotalFollowing = 0
    var TotalFollowers = 0
    var TotalMessage = 0
    var TotalPostView = 0
    var TotalPostSave = 0
    var TotalPortfolioView = 0
    var TotalPortfolioSave = 0
    var PortfolioList:[TopsView] = []
    var PostList:[TopsView] = []

    override init(){
        
    }
    required init?(map : Map) {
        TotalProfileView <- map["TotalProfileView"]
        TotalProfileSave <- map["TotalProfileSave"]
        TotalFollowing <- map["TotalFollowing"]
        TotalFollowers <- map["TotalFollowers"]
        TotalMessage <- map["TotalMessage"]
        TotalPostView <- map["TotalPostView"]
        TotalPostSave <- map["TotalPostSave"]
        TotalPortfolioView <- map["TotalPortfolioView"]
        TotalPortfolioSave <- map["TotalPortfolioSave"]
        PortfolioList <- map["PortfolioList"]
        PostList <- map["PostList"]
        
    }
     func mapping(map: Map) {
        TotalProfileView <- map["TotalProfileView"]
        TotalProfileSave <- map["TotalProfileSave"]
        TotalFollowing <- map["TotalFollowing"]
        TotalFollowers <- map["TotalFollowers"]
        TotalMessage <- map["TotalMessage"]
        TotalPostView <- map["TotalPostView"]
        TotalPostSave <- map["TotalPostSave"]
        TotalPortfolioView <- map["TotalPortfolioView"]
        TotalPortfolioSave <- map["TotalPortfolioSave"]
        PortfolioList <- map["PortfolioList"]
        PostList <- map["PostList"]
    }
}
class TopsView:NSObject,Mappable
{
    
    var TotalPageView = 0
    var TotalPageSave = 0
    var Title = ""
    override init(){
        
    }
    required init?(map : Map) {
        TotalPageView <- map["TotalPageView"]
        TotalPageSave <- map["TotalPageSave"]
        Title <- map["Title"]
    }
    func mapping(map: Map) {
        TotalPageView <- map["TotalPageView"]
        TotalPageSave <- map["TotalPageSave"]
         Title <- map["Title"]
    }

}
class Follower:NSObject,Mappable
{
    var PrimaryID = 0
    var UserID  = 0
    var Name = ""
    var ContractorID = 0
    var CompanyID = 0
    var ProfileImageLink = ""
    var TradeCategoryName = ""
    var CityName = ""
    var IsSaved : Bool = false
    var IsFollow : Bool = false
    var IsContractor : Bool = false
    
    override init(){
        
    }
    required init?(map : Map)
    {
         PrimaryID <- map["PrimaryID"]
         UserID <- map["UserID"]
         ProfileImageLink <- map["ProfileImageLink"]
         IsSaved <- map["IsSaved"]
         Name <- map["Name"]
         TradeCategoryName <- map["TradeCategoryName"]
         CityName <- map["CityName"]
         ContractorID <- map["ContractorID"]
         CompanyID <- map["CompanyID"]
         IsFollow <- map["IsFollow"]
        IsContractor <- map["IsContractor"]


    }
    func mapping(map: Map)
    {
        PrimaryID <- map["PrimaryID"]
        UserID <- map["UserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        IsFollow <- map["IsFollow"]
        IsContractor <- map["IsContractor"]

    }
}
class Following:NSObject,Mappable
{
    var PrimaryID = 0
    var UserID  = 0
    var Name = ""
    var ContractorID = 0
    var CompanyID = 0
    var ProfileImageLink = ""
    var TradeCategoryName = ""
    var CityName = ""
    var IsSaved : Bool = false
    var IsFollow : Bool = false
    var IsContractor : Bool = false
    
    override init(){
        
    }
    required init?(map : Map)
    {
        PrimaryID <- map["PrimaryID"]
        UserID <- map["UserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        IsFollow <- map["IsFollow"]
        IsContractor <- map["IsContractor"]
    }
    func mapping(map: Map)
    {
        PrimaryID <- map["PrimaryID"]
        UserID <- map["UserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        IsFollow <- map["IsFollow"]
        IsContractor <- map["IsContractor"]
    }
}
