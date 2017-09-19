//
//  DashBoradNM.swift
//  Tooli
//
//  Created by Impero IT on 18/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import Foundation

import UIKit
import ObjectMapper

class DashBoradAllData: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : ResultsDashBorad = ResultsDashBorad()
    
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
class ResultsDashBorad: NSObject, Mappable  {

    var UserData : UserDataM = UserDataM()
    var UserSuggestionList : [UserSuggestionM] = []
    var DashboardList : [DashboardNM] = []
    
    override init()
    {
        
    }
    required init?(map: Map){
        UserData <- map["UserData"]
        UserSuggestionList <- map["UserSuggestionList"]
        DashboardList <- map["DashboardList"]
    }
    func mapping(map: Map) {
        UserData <- map["UserData"]
        UserSuggestionList <- map["UserSuggestionList"]
        DashboardList <- map["DashboardList"]

    }
}
class UserDataM: NSObject, Mappable  {
    
    var ProfileImageLink = ""
    var Name = ""
    var ReferralLink = ""
    var UserID = ""
    var ReferralCode = ""
    var CompanyName = ""
    var TradeName = ""
    var Role = 0
    
    override init()
    {
        
    }
    required init?(map: Map){
        ProfileImageLink <- map["ProfileImageLink"]
         Name <- map["Name"]
         ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        Role <- map["Role"]
    }
    func mapping(map: Map) {
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        UserID <- map["UserID"]
        ReferralCode <- map["ReferralCode"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        Role <- map["Role"]
    }
}

class UserSuggestionM: NSObject, Mappable
{
    var UserID = ""
    var ProfileImageLink = ""
    var Name = ""
    var TradeName = ""
    var Role = 0
    
    override init()
    {
        
    }
    required init?(map: Map){
         UserID <- map["UserID"]
         ProfileImageLink <- map["ProfileImageLink"]
         Name <- map["Name"]
         TradeName <- map["TradeName"]
         Role <- map["Role"]
        
    }
    func mapping(map: Map) {
        UserID <- map["UserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        TradeName <- map["TradeName"]
        Role <- map["Role"]
    }
}
class DashboardNM: NSObject, Mappable
{
    var PageType = 0
    var PrimaryID = ""
    var IsMe:Bool = false
    var UserID = ""
    var Role = 0
    var JobView:JobViewM = JobViewM()
    var UserView:UserViewM = UserViewM()
    var OfferView:OfferViewM = OfferViewM()
    var PortfolioView:PortfolioViewM = PortfolioViewM()
    var PostView:PostViewM = PostViewM()
    
    override init()
    {
        
    }
    required init?(map: Map){
         PageType <- map["PageType"]
         PrimaryID <- map["TablePrimaryID"]
         IsMe <- map["IsMe"]
         UserID <- map["UserID"]
         Role <- map["Role"]
         JobView <- map["JobView"]
         UserView <- map["UserView"]
         OfferView <- map["OfferView"]
         PortfolioView <- map["PortfolioView"]
         PostView <- map["PostView"]
    }
    func mapping(map: Map) {
        PageType <- map["PageType"]
        PrimaryID <- map["TablePrimaryID"]
        IsMe <- map["IsMe"]
        UserID <- map["UserID"]
        Role <- map["Role"]
        JobView <- map["JobView"]
        UserView <- map["UserView"]
        OfferView <- map["OfferView"]
        PortfolioView <- map["PortfolioView"]
        PostView <- map["PostView"]
    }
}

class UserViewM: NSObject, Mappable
{
    var CityName = ""
    var CompanyName = ""
    var Description = ""
    var DistanceAwayText = ""
    var FullName = ""
    var ProfileImageLink = ""
    var TradeName = ""
    var UserID = ""
    var IsSaved:Bool = false
    override init()
    {
        
    }
    required init?(map: Map){
        CityName <- map["CityName"]
        CompanyName <- map["CompanyName"]
        Description <- map["Description"]
        DistanceAwayText <- map["DistanceAwayText"]
        FullName <- map["FullName"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeName <- map["TradeName"]
        UserID <- map["UserID"]
        IsSaved <- map["IsSaved"]
    }
    func mapping(map: Map)
    {
        CityName <- map["CityName"]
        CompanyName <- map["CompanyName"]
        Description <- map["Description"]
        DistanceAwayText <- map["DistanceAwayText"]
        FullName <- map["FullName"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeName <- map["TradeName"]
        UserID <- map["UserID"]
        IsSaved <- map["IsSaved"]
    }
}

class JobViewM: NSObject, Mappable  {
    
    var JobID = 0
    var CompanyName = ""
    var TradeName = ""
    var CityName = ""
    var IsSaved:Bool = false
    var IsApplied:Bool = false
    var TimeCaption = ""
    var Description = ""
    var DistanceInMiles = ""
    var DistanceAwayText = ""
    var TotalApplied = 0
    var TotalSaved = 0
    var TotalViewed = 0
    var IsClose:Bool = false
    var JobTradeName = ""
    var ProfileImageLink = ""
    var Name = ""
    var ReferralLink = ""
    var ReferralCode = ""
    var StartDate = ""
    var EndDate = ""
    var CertificateNameList:[String] = []
    var SectorNameList:[String] = []
    var UserID = ""
    
    var UserCityName = ""
    var JobRoleName = ""
    var Role = 0
    var IsUserSaved:Bool = false
    var TotalFollower = 0
    var TotalFollowing = 0
    var IsFollow:Bool = false
    var IsFollowing:Bool = false
    var IsMe:Bool = false
    
    override init()
    {
        
    }
    required init?(map: Map)
    {
        JobID <- map["JobID"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        CityName <- map["CityName"]
        IsSaved <- map["IsSaved"]
        IsApplied <- map["IsApplied"]
        TimeCaption <- map["TimeCaption"]
        Description <- map["Description"]
        DistanceInMiles <- map["DistanceInMiles"]
        DistanceAwayText <- map["DistanceAwayText"]
        TotalApplied <- map["TotalApplied"]
        TotalSaved <- map["TotalSaved"]
        TotalViewed <- map["TotalViewed"]
        IsClose <- map["IsClose"]
        JobTradeName <- map["JobTradeName"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        StartDate <- map["StartDate"]
        EndDate <- map["EndDate"]
        CertificateNameList <- map["CertificateNameList"]
        SectorNameList <- map["SectorNameList"]
        UserID <- map["UserID"]
        IsApplied <- map["IsApplied"]
         UserCityName <- map["UserCityName"]
         JobRoleName <- map["JobRoleName"]
         Role <- map["Role"]
         IsUserSaved <- map["IsUserSaved"]
         TotalFollower <- map["TotalFollower"]
         TotalFollowing <- map["TotalFollowing"]
         IsFollow <- map["IsFollow"]
         IsFollowing <- map["IsFollowing"]
        IsMe <- map["IsMe"]
    }
    func mapping(map: Map) {
        JobID <- map["JobID"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        CityName <- map["CityName"]
        IsSaved <- map["IsSaved"]
        TimeCaption <- map["TimeCaption"]
        Description <- map["Description"]
        DistanceInMiles <- map["DistanceInMiles"]
        DistanceAwayText <- map["DistanceAwayText"]
        TotalApplied <- map["TotalApplied"]
        TotalSaved <- map["TotalSaved"]
        TotalViewed <- map["TotalViewed"]
        IsClose <- map["IsClose"]
        JobTradeName <- map["JobTradeName"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        StartDate <- map["StartDate"]
        EndDate <- map["EndDate"]
        CertificateNameList <- map["CertificateNameList"]
        SectorNameList <- map["SectorNameList"]
        UserID <- map["UserID"]
        IsApplied <- map["IsApplied"]
        UserCityName <- map["UserCityName"]
        JobRoleName <- map["JobRoleName"]
        Role <- map["Role"]
        IsUserSaved <- map["IsUserSaved"]
        TotalFollower <- map["TotalFollower"]
        TotalFollowing <- map["TotalFollowing"]
        IsFollow <- map["IsFollow"]
        IsFollowing <- map["IsFollowing"]
        IsMe <- map["IsMe"]
    }
}

class OfferViewM: NSObject, Mappable  {
    
    var OfferID = 0
    var Title = ""
    var ImageLink = ""
    var IsSaved:Bool = false
    var TimeCaption = ""
    var Description = ""
    var PriceTag = ""
    var EmailID = ""
    var Website = ""
    var CompanyName = ""
    var TradeName = ""
    var TotalSaved = ""
    var TotalViewed = ""
    var IsClose:Bool = false
    var OfferTradeName = ""
    var ProfileImageLink = ""
    var Name = ""
    var ReferralLink = ""
    var ReferralCode = ""
    var UserID = ""
    var Role = 0
    override init()
    {
        
    }
    required init?(map: Map){
        OfferID <- map["OfferID"]
        Role <- map["Role"]
        Title <- map["Title"]
        ImageLink <- map["ImageLink"]
        IsSaved <- map["IsSaved"]
        TimeCaption <- map["TimeCaption"]
        Description <- map["Description"]
        PriceTag <- map["PriceTag"]
        EmailID <- map["EmailID"]
        Website <- map["Website"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        OfferTradeName <- map["OfferTradeName"]
        TotalSaved <- map["TotalSaved"]
        TotalViewed <- map["TotalViewed"]
        IsClose <- map["IsClose"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        UserID <- map["UserID"]
        
    }
    func mapping(map: Map) {
        OfferID <- map["OfferID"]
        Role <- map["Role"]
        Title <- map["Title"]
        ImageLink <- map["ImageLink"]
        IsSaved <- map["IsSaved"]
        TimeCaption <- map["TimeCaption"]
        Description <- map["Description"]
        PriceTag <- map["PriceTag"]
        EmailID <- map["EmailID"]
        Website <- map["Website"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        OfferTradeName <- map["OfferTradeName"]
        TotalSaved <- map["TotalSaved"]
        TotalViewed <- map["TotalViewed"]
        IsClose <- map["IsClose"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        UserID <- map["UserID"]
    }
}

class PortfolioViewM: NSObject, Mappable  {
    
    var PortfolioID = 0
    var Title = ""
    var Location = ""
    var Description = ""
    var CustomerName = ""
    var TimeCaption = ""
    var TitleCaption = ""
    var IsSaved:Bool = false
    var PortfolioImageList:[PortfolioImageM] = []
    var ProfileImageLink = ""
    var TradeName = ""
    var CompanyName = ""
    var Name = ""
    var ReferralLink = ""
    var ReferralCode = ""
    var UserID = ""
    
    override init()
    {
        
    }
    required init?(map: Map){
        
        PortfolioID <- map["PortfolioID"]
        Title <- map["Title"]
        Location <- map["Location"]
        Description <- map["Description"]
        CustomerName <- map["CustomerName"]
        PortfolioImageList <- map["PortfolioImageList"]
        IsSaved <- map["IsSaved"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        TimeCaption <- map["TimeCaption"]
        TitleCaption <- map["TitleCaption"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        UserID <- map["UserID"]
    }
    func mapping(map: Map) {
        PortfolioID <- map["PortfolioID"]
        Title <- map["Title"]
        Location <- map["Location"]
        Description <- map["Description"]
        CustomerName <- map["CustomerName"]
        PortfolioImageList <- map["PortfolioImageList"]
        IsSaved <- map["IsSaved"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        TimeCaption <- map["TimeCaption"]
        TitleCaption <- map["TitleCaption"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        UserID <- map["UserID"]
    }
}
class PortfolioImageM: NSObject, Mappable  {
    
    var ImageID = 0
    var ImageName = ""
    var ImageLink = ""
    var image:UIImage = UIImage()
    var addedByMe:Bool = false
    
    override init()
    {
        
    }
    required init?(map: Map){
        ImageID <- map["ImageID"]
        ImageName <- map["ImageName"]
        ImageLink <- map["ImageLink"]
    }
    func mapping(map: Map) {
        ImageID <- map["ImageID"]
        ImageName <- map["ImageName"]
        ImageLink <- map["ImageLink"]
    }
}
class PostViewM: NSObject, Mappable  {
    
    var PostID = 0
    var UserID = ""
    var Name = ""
    var ProfileImageLink = ""
    var StatusText = ""
    var TimeCaption = ""
    var IsSaved:Bool = false
    var CompanyName = ""
    var TradeName = ""
    var ReferralLink = ""
    var ReferralCode = ""
    
    override init()
    {
        
    }
    required init?(map: Map){
        
        PostID <- map["PostID"]
        UserID <- map["UserID"]
        Name <- map["Name"]
        ProfileImageLink <- map["ProfileImageLink"]
        StatusText <- map["StatusText"]
        TimeCaption <- map["TimeCaption"]
        IsSaved <- map["IsSaved"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
        
    }
    func mapping(map: Map) {
        PostID <- map["PostID"]
        UserID <- map["UserID"]
        Name <- map["Name"]
        ProfileImageLink <- map["ProfileImageLink"]
        StatusText <- map["StatusText"]
        TimeCaption <- map["TimeCaption"]
        IsSaved <- map["IsSaved"]
        CompanyName <- map["CompanyName"]
        TradeName <- map["TradeName"]
        ReferralLink <- map["ReferralLink"]
        ReferralCode <- map["ReferralCode"]
    }
}



class SuggestionUserList: NSObject, Mappable{
    
    var status = ""
    var message = ""
    var DataList : [UserModel]? = []
    
    override init()
    {
        
    }
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

class UserModel : NSObject, Mappable
{
    var UserID = 0
    var ContractorID = 0
    var CompanyID = 0
    var IsContractor : Bool = true
    var Name = ""
    var TradeCategoryName = ""
    var ImageLink = ""
    var ProfileViewLink = ""
    
    required init?(map: Map) {
        UserID <- map["UserID"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        IsContractor <- map["IsContractor"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        ImageLink <- map["ImageLink"]
        ProfileViewLink <- map["ProfileViewLink"]
    }
    func mapping(map: Map) {
        
        UserID <- map["UserID"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        IsContractor <- map["IsContractor"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        ImageLink <- map["ImageLink"]
        ProfileViewLink <- map["ProfileViewLink"]
    }
}
