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

class GetAllBuddyList: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : [BuddyM] = []
    
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
class BuddyM: NSObject, Mappable  {

    var IsSendByMe = false
    var ChatUserID = ""
    var ProfileImageLink = ""
    var Name = ""
    var LastMessageText = ""
    var LastMessageTimeCaption = ""
    var LastMessageDate = ""
    var IsReadLastMessage = false
    var Role = 0
    override init()
    {
        
    }
    required init?(map: Map)
    {
        IsSendByMe <- map["IsSendByMe"]
        ChatUserID <- map["ChatUserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        LastMessageText <- map["LastMessageText"]
        LastMessageTimeCaption <- map["LastMessageTimeCaption"]
        LastMessageDate <- map["LastMessageDate"]
        IsReadLastMessage <- map["IsReadLastMessage"]
        Role <- map["Role"]
    }
    func mapping(map: Map)
    {
        IsSendByMe <- map["IsSendByMe"]
        ChatUserID <- map["ChatUserID"]
        ProfileImageLink <- map["ProfileImageLink"]
        Name <- map["Name"]
        LastMessageText <- map["LastMessageText"]
        LastMessageTimeCaption <- map["LastMessageTimeCaption"]
        LastMessageDate <- map["LastMessageDate"]
        IsReadLastMessage <- map["IsReadLastMessage"]
        Role <- map["Role"]
    }
}
/*
 "IsSendByMe": true,
 "ChatUserID": "sample string 2",
 "ProfileImageLink": "sample string 3",
 "Name": "sample string 4",
 "LastMessageText": "sample string 5",
 "LastMessageTimeCaption": "sample string 6",
 "LastMessageDate": "2017-08-25T15:47:12.9789407+05:30",
 "IsReadLastMessage": true
 */
