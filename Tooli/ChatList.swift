//
//  ChatList.swift
//  R8IT
//
//  Created by Impero IT on 26/10/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import ObjectMapper
class MessageList: NSObject, Mappable {
    var status = ""
    var message = ""
    var DataList : [Messages]!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
    }
}
class UnreadCountResponse:NSObject,Mappable
{
    required init?(map: Map) {
        AppDelegate.sharedInstance().sharedManager.unreadMessage <- map["UnreadMessageGroupCount"]
        AppDelegate.sharedInstance().sharedManager.unreadNotification <- map["UnreadNotificationCount"]
        AppDelegate.sharedInstance().sharedManager.unreadSpecialOffer <- map["UnreadOfferNotificationCount"]
        
        UIApplication.shared.applicationIconBadgeNumber =  AppDelegate.sharedInstance().sharedManager.unreadSpecialOffer + AppDelegate.sharedInstance().sharedManager.unreadNotification + AppDelegate.sharedInstance().sharedManager.unreadMessage
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
    }
    func mapping(map: Map) {
     AppDelegate.sharedInstance().sharedManager.unreadMessage <- map["UnreadMessageGroupCount"]
     AppDelegate.sharedInstance().sharedManager.unreadNotification <- map["UnreadNotificationCount"]
     AppDelegate.sharedInstance().sharedManager.unreadSpecialOffer <- map["UnreadOfferNotificationCount"]
        
        UIApplication.shared.applicationIconBadgeNumber =  AppDelegate.sharedInstance().sharedManager.unreadSpecialOffer + AppDelegate.sharedInstance().sharedManager.unreadNotification + AppDelegate.sharedInstance().sharedManager.unreadMessage
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
        
    }
}
class ChatHistory : NSObject, Mappable {
    var status = ""
    var message = ""
    var DataList : [Messages]!
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        DataList <- map["DataList"]
    }
}
class Messages : NSObject, Mappable {
    var Name = ""
    var UserImageLink = ""
    var UserID = 0
    var ReceiverID = 0
    var MessageText = ""
    var IsRead : Bool = false
    var IsMe : Bool = false
    var IsOnline : Bool = false
    var MessageDate = ""
    var ChatMessageDate = ""
    var MilliSecond = 0.0

    required init?(map: Map) {
        Name <- map["SenderName"]
        UserImageLink <- map["UserImageLink"]
        UserID <- map["UserID"]
        ReceiverID <- map["ReceiverID"]
        MessageText <- map["MessageText"]
        IsRead <- map["IsRead"]
        IsMe <- map["IsMe"]
        IsOnline <- map["IsOnline"]
        MessageDate <- map["MessageDate"]
        ChatMessageDate <- map["AddedOn"]
        MilliSecond <- map["TotalMiliSecond"]
    }
    func mapping(map: Map) {
        Name <- map["SenderName"]
        UserImageLink <- map["UserImageLink"]
        UserID <- map["UserID"]
        ReceiverID <- map["ReceiverID"]
        MessageText <- map["MessageText"]
        IsRead <- map["IsRead"]
        IsMe <- map["IsMe"]
        IsOnline <- map["IsOnline"]
        MessageDate <- map["MessageDate"]
        ChatMessageDate <- map["AddedOn"]
        MilliSecond <- map["TotalMiliSecond"]
    }
}

class Buddies : NSObject, Mappable {
    var CompanyID = 0
    var ChatUserID = 0
    var ContractorID = 0
    var Name = ""
    var ProfileImageLink = ""
    var IsOnline : Bool = false
    var IsContractor : Bool = false
    var IsReadLastMsg:Bool = false
    var LastOnlineDate = ""
    var UnreadMessage = 0
    var LastMessageText = ""
    var LastMessageOn = ""
    var UnreadCount : UnreadCountResponse!
    required init?(map: Map){
        UnreadCount <- map["UnreadCountResponse"]
    }
    func mapping(map: Map) {
        CompanyID <- map["CompanyID"]
        Name <- map["Name"]
        ProfileImageLink <- map["ProfileImageLink"]
        IsOnline <- map["IsOnline"]
        LastOnlineDate <- map["LastOnlineDate"]
        UnreadMessage <- map["UnreadMessage"]
        LastMessageText <- map["LastMessageText"]
        LastMessageOn <- map["LastMessageOn"]
        ChatUserID <- map["ChatUserID"]
        ContractorID <- map["ContractorID"]
        IsContractor <- map["IsContractor"]
         IsReadLastMsg <- map["IsReadLastMsg"]
         UnreadCount <- map["UnreadCountResponse"]
         NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
    }
}
class ChatList: NSObject, Mappable {
    var status = 0
    var message = ""
    var Users : [Buddies]!
    var OfflineUserList :[Buddies]!
    var OnlineUserList :[Buddies]!
    var UnreadCount : UnreadCountResponse!
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        Users <- map["DataList"]
        OnlineUserList <- map["OnlineUserList"]
        OfflineUserList <- map["OfflineUserList"]
        UnreadCount <- map["UnreadCountResponse"]
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
    }
}

class Command {
    
    static func buddyListCommand() -> NSString{
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("buddylist", forKey: "CommandName")
        para.setValue("0", forKey: "ParamID")
        para.setValue("", forKey: "MessageText")
        para.setValue("0", forKey: "Index")
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: JSONSerialization.WritingOptions())
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String as NSString
    }
    
    static func offlineCommand() -> NSString{
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("offline", forKey: "CommandName")
        para.setValue("0", forKey: "ParamID")
        para.setValue("", forKey: "MessageText")
        para.setValue("0", forKey: "Index")
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: JSONSerialization.WritingOptions())
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String as NSString
    }
    static func chatHistoryCommand(friendId: String ) -> NSString{
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("chathistory", forKey: "CommandName")
        para.setValue(friendId, forKey: "ParamID")
        para.setValue("", forKey: "MessageText")
        para.setValue("0", forKey: "Index")
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: JSONSerialization.WritingOptions())
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String as NSString
    }
    
    static func messageSendCommand(friendId: String, msg : String ) -> NSString{
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("messagesend", forKey: "CommandName")
        para.setValue(friendId, forKey: "ParamID")
        para.setValue(msg, forKey: "MessageText")
        para.setValue("0", forKey: "Index")
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: JSONSerialization.WritingOptions())
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String as NSString
    }
    
    static func readReceiptCommand(friendId: String ) -> NSString{
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue("readreceipt", forKey: "CommandName")
        para.setValue(friendId, forKey: "ParamID")
        para.setValue("", forKey: "MessageText")
        para.setValue("0", forKey: "Index")
        let jsonData = try! JSONSerialization.data(withJSONObject: para, options: JSONSerialization.WritingOptions())
        return NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String as NSString
    }
}
