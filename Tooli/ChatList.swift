//
//  ChatList.swift
//  R8IT
//
//  Created by Impero IT on 26/10/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import ObjectMapper
class UnreadCountResponse: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : UnreadCount = UnreadCount()
    
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
class UnreadCount:NSObject,Mappable
{
    override init()
    {
        
    }
    required init?(map: Map)
    {
        AppDelegate.sharedInstance().sharedManager.unreadAllNotification <- map["unreadAllNotification"]
        AppDelegate.sharedInstance().sharedManager.unreadMessage <- map["unreadMessage"]
        AppDelegate.sharedInstance().sharedManager.unreadBuddyGroup <- map["unreadBuddyGroup"]
        AppDelegate.sharedInstance().sharedManager.unreadOfferNotification <- map["unreadOfferNotification"]
        
        UIApplication.shared.applicationIconBadgeNumber =  AppDelegate.sharedInstance().sharedManager.unreadAllNotification + AppDelegate.sharedInstance().sharedManager.unreadBuddyGroup + AppDelegate.sharedInstance().sharedManager.unreadOfferNotification
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
    }
    func mapping(map: Map)
    {
        AppDelegate.sharedInstance().sharedManager.unreadAllNotification <- map["unreadAllNotification"]
        AppDelegate.sharedInstance().sharedManager.unreadMessage <- map["unreadMessage"]
        AppDelegate.sharedInstance().sharedManager.unreadBuddyGroup <- map["unreadBuddyGroup"]
        AppDelegate.sharedInstance().sharedManager.unreadOfferNotification <- map["unreadOfferNotification"]
        
        UIApplication.shared.applicationIconBadgeNumber =  AppDelegate.sharedInstance().sharedManager.unreadAllNotification + AppDelegate.sharedInstance().sharedManager.unreadBuddyGroup + AppDelegate.sharedInstance().sharedManager.unreadOfferNotification
        
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
        
    }
}
