//
//  File.swift
//  Tooli
//
//  Created by Impero IT on 11/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import Foundation

import UIKit
import ObjectMapper

class GetAllNotificationList: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : [NotificationResults] = []
    
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
class NotificationResults: NSObject, Mappable  {
    
     var NotificationID = 0
     var TablePrimaryID = ""
     var NotificationText = ""
     var NotificationStatus = 0
     var NotificationPageType = 0
     var ProfileImageLink = ""
     var Name = ""
     var CompanyName = ""
     var TimeCaption = ""
     var IsRead = false
     var UserID = ""
     var Role = 0

    
    override init()
    {
        
    }
    required init?(map: Map){
        NotificationID <- map["NotificationID"]
        TablePrimaryID <- map["TablePrimaryID"]
        NotificationText <- map["NotificationText"]
        NotificationStatus <- map["NotificationStatus"]
        NotificationPageType <- map["NotificationPageType"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        CompanyName <- map["CompanyName"]
        TimeCaption <- map["TimeCaption"]
        IsRead <- map["IsRead"]
        UserID <- map["UserID"]
         Role <- map["Role"]
    }
    func mapping(map: Map) {
        NotificationID <- map["NotificationID"]
        TablePrimaryID <- map["TablePrimaryID"]
        NotificationText <- map["NotificationText"]
        NotificationStatus <- map["NotificationStatus"]
        NotificationPageType <- map["NotificationPageType"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        CompanyName <- map["CompanyName"]
        TimeCaption <- map["TimeCaption"]
        IsRead <- map["IsRead"]
        UserID <- map["UserID"]
        Role <- map["Role"]    }
}
