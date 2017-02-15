//
//  SearchContractoreList.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class SearchContractoreList: NSObject, Mappable  {
    
    
    var status = ""
    var message = ""
    var DataList : [SerachDashBoardM]? = []
    
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

class SerachDashBoardM : NSObject, Mappable

{

    var value = ""
    var displayvalue = ""
    var RedirectLink = ""
    var IsContractor = false
    var PrimaryID = 0
    
    required init?(map: Map) {

         value <- map["value"]
         displayvalue <- map["displayvalue"]
         RedirectLink <- map["RedirectLink"]
         IsContractor <- map["IsContractor"]
         PrimaryID <- map["PrimaryID"]
    }
    func mapping(map: Map) {
        
        value <- map["value"]
        displayvalue <- map["displayvalue"]
        RedirectLink <- map["RedirectLink"]
        IsContractor <- map["IsContractor"]
        PrimaryID <- map["PrimaryID"]
    }
}

class FilterContractoreList: NSObject, Mappable {
    var status = "0"
    var message = ""
    var DataList : [ContractoreDetail] = []
    
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
class ContractoreDetail: NSObject, Mappable {
    var CityName = ""
    var PrimaryID = 0
    var Name = ""
    var AvailableStatusIcon = ""
    var DistanceText = ""
    var TradeCategoryName = ""
    var PageTypeID = 0
    var SavePageStarImageLink = ""
    var DistanceRadius = 0
    var ProfileImageLink = ""
    var UserFullName = ""
    var UserID = 0
    var JobTitle = ""
    var Aboutme = ""
    var IsSaved = false
    
    required override init(){
        
    }
    required init?(map : Map) {
        
    }
    func mapping(map: Map) {
        CityName <- map["CityName"]
        PrimaryID <- map["PrimaryID"]
        Name <- map["Name"]
        AvailableStatusIcon <- map["AvailableStatusIcon"]
        DistanceText <- map["DistanceText"]
        TradeCategoryName <- map["TradeCategoryName"]
        PageTypeID <- map["PageTypeID"]
        SavePageStarImageLink <- map["SavePageStarImageLink"]
        DistanceRadius <- map["DistanceRadius"]
        ProfileImageLink <- map["ProfileImageLink"]
        UserFullName <- map["UserFullName"]
        UserID <- map["UserID"]
        JobTitle <- map["JobTitle"]
        Aboutme <- map["Aboutme"]
        IsSaved <- map["IsSaved"]
    }
}
