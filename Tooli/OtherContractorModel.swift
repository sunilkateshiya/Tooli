//
//  OtherContractorModel.swift
//  TooliDemo
//
//  Created by Azharhussain on 21/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class OtherContractorModel: NSObject, Mappable  {
     
     
     var Status = 0
     var Message = ""
     var Result : ResultsContractorProfileView = ResultsContractorProfileView()
     
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
class ResultsContractorProfileView: NSObject, Mappable  {
     var UserID =  ""
     var FullName =  ""
     var ProfileImageLink = ""
     var IsSaved  = false
     var DepartmentName =  ""
     var TradeName =  ""
     var CityName =  ""
     var TotalFollower = 0
     var TotalFollowing = 0
     var IsFollow = false
     var IsFollowing = false
     var Description =  ""
     var BirthDate =  ""
     var CompanyName =  ""
     var IsEmailPublic = false
     var IsPhonePublic = false
     var IsMobilePublic = false
     var MobileNumber =  ""
     var PhoneNumber =  ""
     var CompanyEmailID =  ""
     var Website =  ""
     var DistanceRadius = 0
     var AvailableStatus = 0
     var PerHourRate =  ""
     var IsPerHourRatePublic = false
     var PerDayRate = ""
     var IsPerDayRatePublic = false
     var IsOwnVehicle = false
     var IsLicenceHeld = false
     var JobRoleNameList : [String] = []
     var TradeNameList : [String] = []
     var SubTradeNameList : [String] = []
     var SectorNameList : [String] = []
     var ServiceNameList : [String] = []
     var RateAndTraval : [String] = []
     var ExperinceList  : [ExperienceM] = []
     var CertificateList  : [DefualtCertificateM] = []
     var ActivityList : [DashboardNM] = []
     var PortfolioList : [PortfolioViewM] = []
     var FollowerUserList : [FollowingUserListM] = []
     var FollowingUserList : [FollowingUserListM] = []
     
     override init()
     {
          
     }
     required init?(map: Map){
          UserID <- map["UserID"]
          FullName <- map["FullName"]
          ProfileImageLink <- map["ProfileImageLink"]
          IsSaved  <- map["IsSaved"]
          DepartmentName <- map["DepartmentName"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]
          AvailableStatus <- map["AvailableStatus"]
          
          Description <- map["Description"]
          BirthDate <- map["BirthDate"]
          CompanyName <- map["CompanyName"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
          DistanceRadius <- map["DistanceRadius"]
          PerHourRate <- map["PerHourRate"]
          IsPerHourRatePublic <- map["IsPerHourRatePublic"]
          PerDayRate <- map["PerDayRate"]
          IsPerDayRatePublic <- map["IsPerDayRatePublic"]
          IsOwnVehicle <- map["IsOwnVehicle"]
          IsLicenceHeld <- map["IsLicenceHeld"]
          JobRoleNameList <- map["JobRoleNameList"]
          TradeNameList <- map["TradeNameList"]
          SubTradeNameList <- map["SubTradeNameList"]
          SectorNameList <- map["SectorNameList"]
          ServiceNameList <- map["ServiceNameList"]
          ExperinceList <- map["ExperinceList"]
          CertificateList <- map["CertificateList"]
          ActivityList <- map["ActivityList"]
          PortfolioList <- map["PortfolioList"]
          FollowerUserList <- map["FollowerUserList"]
          FollowingUserList <- map["FollowingUserList"]
     }
     func mapping(map: Map) {
          UserID <- map["UserID"]
          FullName <- map["FullName"]
          ProfileImageLink <- map["ProfileImageLink"]
          IsSaved  <- map["IsSaved"]
          DepartmentName <- map["DepartmentName"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          AvailableStatus <- map["AvailableStatus"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]
          Description <- map["Description"]
          BirthDate <- map["BirthDate"]
          CompanyName <- map["CompanyName"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
          DistanceRadius <- map["DistanceRadius"]
          PerHourRate <- map["PerHourRate"]
          IsPerHourRatePublic <- map["IsPerHourRatePublic"]
          PerDayRate <- map["PerDayRate"]
          IsPerDayRatePublic <- map["IsPerDayRatePublic"]
          IsOwnVehicle <- map["IsOwnVehicle"]
          IsLicenceHeld <- map["IsLicenceHeld"]
          JobRoleNameList <- map["JobRoleNameList"]
          TradeNameList <- map["TradeNameList"]
          SubTradeNameList <- map["SubTradeNameList"]
          SectorNameList <- map["SectorNameList"]
          ServiceNameList <- map["ServiceNameList"]
          ExperinceList <- map["ExperinceList"]
          CertificateList <- map["CertificateList"]
          ActivityList <- map["ActivityList"]
          PortfolioList <- map["PortfolioList"]
          FollowerUserList <- map["FollowerUserList"]
          FollowingUserList <- map["FollowingUserList"]

     }
}
class OtherExperienceList: NSObject, Mappable  {
     
     var Title = ""
     var CompanyName = ""
     var ExperienceYear = ""
     
     override init()
     {
          
     }
     required init?(map: Map){
          Title <- map["Title"]
          CompanyName <- map["CompanyName"]
          ExperienceYear <- map["ExperienceYear"]
     }
     func mapping(map: Map) {
          Title <- map["Title"]
          CompanyName <- map["CompanyName"]
          ExperienceYear <- map["ExperienceYear"]
     }
}
class OtherCertificateList: NSObject, Mappable  {
     
     var CertificateID = 0
     var CertificateFileLink = ""
     var FileType = ""
     var CertificateName = ""
     
     
     override init()
     {
          
     }
     required init?(map: Map){
          CertificateID <- map["CertificateID"]
          CertificateFileLink <- map["CertificateFileLink"]
          FileType <- map["FileType"]
           CertificateName <- map["CertificateName"]
     }
     func mapping(map: Map) {
          CertificateID <- map["CertificateID"]
          CertificateFileLink <- map["CertificateFileLink"]
          FileType <- map["FileType"]
          CertificateName <- map["CertificateName"]
     }
}
class OtherActivityList: NSObject, Mappable  {
     
     var Title = ""
     var CompanyName = ""
     var ExperienceYear = ""
     
     override init()
     {
          
     }
     required init?(map: Map){
          Title <- map["Title"]
          CompanyName <- map["CompanyName"]
          ExperienceYear <- map["ExperienceYear"]
     }
     func mapping(map: Map) {
          Title <- map["Title"]
          CompanyName <- map["CompanyName"]
          ExperienceYear <- map["ExperienceYear"]
     }
}

class FollowerUserListM: NSObject, Mappable  {
     
      var PageType = 0
     var UserID = ""
     var Name = ""
     var TradeName = ""
     var ProfileImageLink = ""
     var CityName = ""
     var DistanceAwayText = ""
     var Description = ""
     var IsSaved : Bool = false
     var IsMe : Bool = false
     var IsFollowing : Bool = false
     var Role = 0
     
     
     override init()
     {
          
          
     }
     required init?(map: Map)
     {
          PageType <- map["PageType"]
          UserID <- map["UserID"]
          Name <- map["Name"]
          TradeName <- map["TradeName"]
          ProfileImageLink <- map["ProfileImageLink"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          IsSaved <- map["IsSaved"]
          IsMe <- map["IsMe"]
          IsFollowing <- map["IsFollowing"]
          Role <- map["Role"]
     }
     func mapping(map: Map)
     {
          PageType <- map["PageType"]
          UserID <- map["UserID"]
          Name <- map["Name"]
          TradeName <- map["TradeName"]
          ProfileImageLink <- map["ProfileImageLink"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          IsSaved <- map["IsSaved"]
          IsMe <- map["IsMe"]
          IsFollowing <- map["IsFollowing"]
          Role <- map["Role"]
     }
}
class FollowingUserListM: NSObject, Mappable  {
     
     var PageType = 0
     var UserID = ""
     var Name = ""
     var TradeName = ""
     var ProfileImageLink = ""
     var CityName = ""
     var DistanceAwayText = ""
     var Description = ""
     var IsSaved : Bool = false
     var IsMe : Bool = false
     var IsFollowing : Bool = false
     var Role = 0
     
     
     override init()
     {
          
          
     }
     required init?(map: Map)
     {
          PageType <- map["PageType"]
          UserID <- map["UserID"]
          Name <- map["Name"]
          TradeName <- map["TradeName"]
          ProfileImageLink <- map["ProfileImageLink"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          IsSaved <- map["IsSaved"]
          IsMe <- map["IsMe"]
          IsFollowing <- map["IsFollowing"]
          Role <- map["Role"]
     }
     func mapping(map: Map)
     {
          PageType <- map["PageType"]
          UserID <- map["UserID"]
          Name <- map["Name"]
          TradeName <- map["TradeName"]
          ProfileImageLink <- map["ProfileImageLink"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          IsSaved <- map["IsSaved"]
          IsMe <- map["IsMe"]
          IsFollowing <- map["IsFollowing"]
          Role <- map["Role"]
     }
}
