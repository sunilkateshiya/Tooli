//
//  CompanyProfileModel.swift
//  TooliDemo
//
//  Created by Azharhussain on 23/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CompanyProfileModel: NSObject, Mappable  {
     
     
     var Status = 0
     var Message = ""
     var Result : ResultsCompanyProfileModel = ResultsCompanyProfileModel()
     
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
class ResultsCompanyProfileModel: NSObject, Mappable
{
     var UserID =  ""
     var ProfileImageLink = ""
     var CompanyName =  ""
     var IsSaved  = false
     var TradeName =  ""
     var CityName =  ""
     var TotalFollower = 0
     var TotalFollowing = 0
     var IsFollow = false
     var IsFollowing = false

     var IsEmailPublic = false
     var IsPhonePublic = false
     var IsMobilePublic = false
     var MobileNumber =  ""
     var PhoneNumber =  ""
     var CompanyEmailID =  ""
     var Website =  ""
     var Description =  ""
     var TradeNameList : [String] = []
     var ServiceNameList : [String] = []
     var JobList : [JobViewM] = []
     var OfferList : [OfferViewM] = []
    
     override init()
     {
          
     }
     required init?(map: Map){
          UserID <- map["UserID"]
          IsSaved  <- map["IsSaved"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]

          Description <- map["Description"]
          CompanyName <- map["CompanyName"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
       
          TradeNameList <- map["TradeNameList"]
          ServiceNameList <- map["ServiceNameList"]
          JobList <- map["JobList"]
          OfferList <- map["OfferList"]
     }
     func mapping(map: Map) {
          UserID <- map["UserID"]
          ProfileImageLink <- map["ProfileImageLink"]
          IsSaved  <- map["IsSaved"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]

          Description <- map["Description"]
          CompanyName <- map["CompanyName"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
          TradeNameList <- map["TradeNameList"]
          ServiceNameList <- map["ServiceNameList"]
          JobList <- map["JobList"]
          OfferList <- map["OfferList"]

     }
}
