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

class GetBuddyMsgList: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : [BuddyMsg] = []
    
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
class BuddyMsg: NSObject, Mappable
{
    var ChatMessageID = 0
    var ChatUserID = ""
    var Name = ""
    var TotalMiliSecond = 0.0
    var IsRead = false
    var IsSendByMe = false
    var TimeCaption = ""
    var ReceiverID = ""
    var MessageText = ""
    var Role = 0
   
    override init()
    {
        
    }
    required init?(map: Map)
    {
        ChatMessageID <- map["ChatMessageID"]
        ChatUserID <- map["ChatUserID"]
        Name <- map["Name"]
        TotalMiliSecond <- map["TotalMiliSecond"]
        IsRead <- map["IsRead"]
        IsSendByMe <- map["IsSendByMe"]
        TimeCaption <- map["TimeCaption"]
        ReceiverID <- map["ReceiverID"]
        MessageText <- map["MessageText"]
        Role <- map["Role"]
    }
    func mapping(map: Map)
    {
        ChatMessageID <- map["ChatMessageID"]
        ChatUserID <- map["ChatUserID"]
        Name <- map["Name"]
        TotalMiliSecond <- map["TotalMiliSecond"]
        IsRead <- map["IsRead"]
        IsSendByMe <- map["IsSendByMe"]
        TimeCaption <- map["TimeCaption"]
        ReceiverID <- map["ReceiverID"]
        MessageText <- map["MessageText"]
        Role <- map["Role"]
    }
}
