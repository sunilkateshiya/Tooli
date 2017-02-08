//
//  User.swift
//  Gymnow
//
//  Created by Impero-Moin on 14/12/16.
//  Copyright © 2016 Impero It. All rights reserved.
//

import UIKit
import ObjectMapper

class ContractorDashBoard: NSObject, Mappable  {
    
    
    var status = ""
    var message = ""
    var DataList : [DashBoardM]? = []
  
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



class DashBoardM : NSObject, Mappable {
    
    
    
    var AddedOn = ""
    var PrimaryID = 0
    var IsPortfolio : Bool = false
    var ProfileImageLink = ""
    var IsSaved : Bool = false
    var Title = ""
    var ContractorID = 0
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
    var PortfolioImageList : [PortfolioImageL]? = []
    
    required init?(map: Map) {
        
        AddedOn <- map["AddedOn"]
        PrimaryID <- map["PrimaryID"]
        IsPortfolio <- map["IsPortfolio"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
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
    }
    func mapping(map: Map) {
        
        AddedOn <- map["AddedOn"]
        PrimaryID <- map["PrimaryID"]
        IsPortfolio <- map["IsPortfolio"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsSaved <- map["IsSaved"]
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

