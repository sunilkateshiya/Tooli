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

class StatisticsModalAllData: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : StatisticsModal = StatisticsModal()
    
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
class StatisticsModal:NSObject,Mappable
{
    var TotalProfileView = 0
    var TotalProfileSave = 0
    var TotalFollowing = 0
    var TotalFollowers = 0
    var TotalMessage = 0
    var TotalPostView = 0
    var TotalPostSave = 0
    var TotalPortfolioView = 0
    var TotalPortfolioSave = 0
    var PortfolioList:[TopsView] = []
    var PostList:[TopsView] = []
    
    override init()
    {
        
    }
    required init?(map : Map) {
        TotalProfileView <- map["TotalProfileView"]
        TotalProfileSave <- map["TotalProfileSave"]
        TotalFollowing <- map["TotalFollowing"]
        TotalFollowers <- map["TotalFollower"]
        TotalMessage <- map["TotalMessage"]
        TotalPostView <- map["TotalPostView"]
        TotalPostSave <- map["TotalPostSave"]
        TotalPortfolioView <- map["TotalPortfolioView"]
        TotalPortfolioSave <- map["TotalPortfolioSave"]
        PortfolioList <- map["PortfolioList"]
        PostList <- map["PostList"]
        
    }
    func mapping(map: Map) {
        TotalProfileView <- map["TotalProfileView"]
        TotalProfileSave <- map["TotalProfileSave"]
        TotalFollowing <- map["TotalFollowing"]
        TotalFollowers <- map["TotalFollower"]
        TotalMessage <- map["TotalMessage"]
        TotalPostView <- map["TotalPostView"]
        TotalPostSave <- map["TotalPostSave"]
        TotalPortfolioView <- map["TotalPortfolioView"]
        TotalPortfolioSave <- map["TotalPortfolioSave"]
        PortfolioList <- map["PortfolioList"]
        PostList <- map["PostList"]
    }
}
class TopsView:NSObject,Mappable
{
    var TotalPageView = 0
    var TotalPageSave = 0
    var Title = ""
    override init()
    {
        
    }
    required init?(map : Map)
    {
        TotalPageView <- map["TotalPageView"]
        TotalPageSave <- map["TotalPageSave"]
        Title <- map["Title"]
    }
    func mapping(map: Map)
    {
        TotalPageView <- map["TotalPageView"]
        TotalPageSave <- map["TotalPageSave"]
        Title <- map["Title"]
    }
}
