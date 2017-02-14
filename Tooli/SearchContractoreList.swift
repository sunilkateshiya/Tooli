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
