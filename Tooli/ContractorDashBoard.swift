//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class ContractorDashBoard: NSObject, Mappable{
    
    var status = ""
    var message = ""
    var DataList : [DashBoardM]? = []
    
    var UnreadMessageNotificationCount = 0
    var UnreadOfferNotificationCount = 0
    var UnreadNotificationCount = 0
    var LastDate = ""
    var MinDate = ""
    
    required init?(map: Map){
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
        UnreadMessageNotificationCount <- map["UnreadMessageGroupCount"]
        UnreadOfferNotificationCount <- map["UnreadOfferNotificationCount"]
        UnreadNotificationCount <- map["UnreadNotificationCount"]
        LastDate <- map["LastDate"]
        MinDate <- map["MinDate"]
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
        UnreadMessageNotificationCount <- map["UnreadMessageGroupCount"]
        UnreadOfferNotificationCount <- map["UnreadOfferNotificationCount"]
        UnreadNotificationCount <- map["UnreadNotificationCount"]
        LastDate <- map["LastDate"]
        MinDate <- map["MinDate"]
    }
}

class SuggestionUserList: NSObject, Mappable{
    
    var status = ""
    var message = ""
    var DataList : [UserModel]? = []
    
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

class UserModel : NSObject, Mappable{
    
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

class DashBoardM : NSObject, Mappable {

    var AddedOn = ""
    var PrimaryID = 0
    var IsPortfolio : Bool = false
    var ProfileImageLink = ""
    var IsSaved : Bool = false
    var Title = ""
    var ContractorID = 0
    var IsContractor = false
    var CompanyID = 0
    var TitleCaption = ""
    var DatetimeCaption = ""
    var PortfolioTitle = ""
    var JobTitle = ""
    var TradeCategoryName = ""
    var StartOn = ""
    var EndOn = ""
    var ThumbnailImageLink = ""
    var Description = ""
    var Location = ""
    var CompanyName = ""
    var CityName = ""
    var Name = ""
    var IsJob = false
    var isStatus = false
    var IsAdminPost = false
    var PortfolioImageList : [PortfolioImageL]? = []
    
    required init?(map: Map) {
        
        AddedOn <- map["AddedOn"]
        PrimaryID <- map["PrimaryID"]
        IsPortfolio <- map["IsPortfolio"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsJob <- map["IsJob"]
        IsSaved <- map["IsSaved"]
        IsContractor <- map["IsContractor"]
        Title <- map["Title"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        TitleCaption <- map["TitleCaption"]
        DatetimeCaption <- map["DatetimeCaption"]
        PortfolioTitle <- map["PortfolioTitle"]
        JobTitle <- map["JobTitle"]
        TradeCategoryName <- map["TradeCategoryName"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        Description <- map["Description"]
        Location <- map["Location"]
        PortfolioImageList <- map["PortfolioImageList"]
        CompanyName <- map["CompanyName"]
        CityName <- map["CityName"]
        isStatus <- map["IsStatus"]
        IsAdminPost <- map["IsAdminPost"]
        Name <- map["Name"]
    }
    func mapping(map: Map) {
        
        AddedOn <- map["AddedOn"]
        PrimaryID <- map["PrimaryID"]
        IsPortfolio <- map["IsPortfolio"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
        IsJob <- map["IsJob"]
        IsContractor <- map["IsContractor"]
        Title <- map["Title"]
        ContractorID <- map["ContractorID"]
        CompanyID <- map["CompanyID"]
        TitleCaption <- map["TitleCaption"]
        DatetimeCaption <- map["DatetimeCaption"]
        PortfolioTitle <- map["PortfolioTitle"]
        JobTitle <- map["JobTitle"]
        TradeCategoryName <- map["TradeCategoryName"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        Description <- map["Description"]
        Location <- map["Location"]
        PortfolioImageList <- map["PortfolioImageList"]
        CompanyName <- map["CompanyName"]
        CityName <- map["CityName"]
        isStatus <- map["IsStatus"]
        IsAdminPost <- map["IsAdminPost"]
        Name <- map["Name"]
    }
}

class PortfolioImageL: NSObject, Mappable {
    
    var PrimaryID = 0
    var PortfolioImageLink = ""
    
    
    required init?(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        PortfolioImageLink <- map["PortfolioImageLink"]
        
    }
    
    func mapping(map: Map) {
        
        PrimaryID <- map["PrimaryID"]
        PortfolioImageLink <- map["PortfolioImageLink"]
        
    }
}
class SavedPageList:NSObject,Mappable
{
    var status = ""
    var message = ""
    
    var OfferList :[OfferListM]? = []
    var JobList :[JobListM]? = []
    var PostList :[Portfolio]? = []
    var CompanieList :[FollowerModel]? = []
    var ContractorList:[DashBoardM]? = []
    
    required init?(map: Map) {
        
         status <- map["status"]
         message <- map["message"]
         OfferList <- map["OfferList"]
         JobList <- map["JobList"]
         PostList <- map["PortfolioList"]
         CompanieList <- map["CompanyList"]
         ContractorList <- map["ContractorList"]
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        OfferList <- map["OfferList"]
        JobList <- map["JobList"]
        PostList <- map["PortfolioList"]
        CompanieList <- map["CompanyList"]
        ContractorList <- map["ContractorList"]
    }

}

class SavedPage:NSObject,Mappable{

    var UserID = 0
    var PrimaryID = 0
    var PageTypeID = 0
    var CompanyName = ""
    var UserFullName = ""
    var SavePageStarImageLink = ""
    var ProfileImageLink = ""
    var Name = ""
    var TradeCategoryName = ""
    var CityName = ""
    var Description = ""
    var UserProfileLink = ""
    var AvailableStatusIcon = ""
    var Aboutme = ""
    var Date = ""
    var Time = ""
    var Location = ""
    var ThumbnailImageLink = ""
    var Caption = ""
    var StartOn = ""
    var EndOn = ""
    var JobViewLink = ""
    var OfferImageLink = ""
    var RedirectLink = ""
    var ViewImageClass = ""
    var PortfolioImageList : [PortfolioImageL]? = []
    

    required init?(map: Map) {
        
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        CompanyName <- map["CompanyName"]
        UserFullName <- map["UserFullName"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        Description <- map["Description"]
        UserProfileLink <- map["UserProfileLink"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        Aboutme <- map["Aboutme"]
        Date <- map["Date"]
        Time <- map["Time"]
        Location <- map["Location"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        Caption <- map["Caption"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        JobViewLink <- map["JobViewLink"]
        OfferImageLink <- map["OfferImageLink"]
        RedirectLink <- map["RedirectLink"]
        ViewImageClass <- map["ViewImageClass"]
        PortfolioImageList <- map["PortfolioImageList"]
    }
    func mapping(map: Map)
    {
        UserID <- map["UserID"]
        PrimaryID <- map["PrimaryID"]
        PageTypeID <- map["PageTypeID"]
        CompanyName <- map["CompanyName"]
        UserFullName <- map["UserFullName"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        TradeCategoryName <- map["TradeCategoryName"]
        CityName <- map["CityName"]
        Description <- map["Description"]
        UserProfileLink <- map["UserProfileLink"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        Aboutme <- map["Aboutme"]
        Date <- map["Date"]
        Time <- map["Time"]
        Location <- map["Location"]
        ThumbnailImageLink <- map["ThumbnailImageLink"]
        Caption <- map["Caption"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
        JobViewLink <- map["JobViewLink"]
        OfferImageLink <- map["OfferImageLink"]
        RedirectLink <- map["RedirectLink"]
        ViewImageClass <- map["ViewImageClass"]
        PortfolioImageList <- map["PortfolioImageList"]
    }
}
