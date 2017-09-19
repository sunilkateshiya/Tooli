
//
//  ContractorProfileModel.swift
//  TooliDemo
//
//  Created by Azharhussain on 23/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class ContractorProfileModel:NSObject, Mappable  {
     
     
     var Status = 0
     var Message = ""
     var Result : ResultsContractorProfileModel = ResultsContractorProfileModel()
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
class ResultsContractorProfileModel: NSObject, Mappable  {
     var IsSaved : Bool  =  false
     var JobRoleName =  ""
     var TotalFollower =  0
     var TotalFollowing =  0
     var IsFollow  : Bool  =  false
     var IsFollowing = false
     var BirthDate =  ""
     var IsEmailPublic  : Bool  =  false
     var IsPhonePublic  : Bool  =  false
     var IsMobilePublic  : Bool  =  false
     var MobileNumber =  ""
     var PhoneNumber =  ""
     var CompanyEmailID =  ""
     var Website =  ""
     var DistanceRadius =  0
     var PerHourRate =  ""
     var IsPerHourRatePublic  : Bool  =  false
     var PerDayRate =  ""
     var IsPerDayRatePublic  : Bool  =  false
     var IsOwnVehicle  : Bool  =  false
     var IsLicenceHeld  : Bool  =  false
     var UserID =  ""
     var FullName =  ""
     var CompanyName =  ""
     var ProfileImageLink =  ""
     var TradeName =  ""
     var CityName =  ""
     var DistanceAwayText =  ""
     var Description =  ""
     var TradeNameList : [String] = []
     var SectorNameList : [String] = []
     var ServiceNameList : [String] = []
     var ExperinceList  : [ExperienceM] = []
     var CertificateList  : [DefualtCertificateM] = []
     var ActivityList : [DashboardNM] = []
     var PortfolioList : [PortfolioViewM] = []
     var FollowerUserList : [FollowerUserListM] = []
     var FollowingUserList : [FollowingUserListM] = []

     override init()
     {
          
     }
     required init?(map: Map){
          IsSaved <- map["IsSaved"]
          JobRoleName <- map["JobRoleName"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]
          BirthDate  <- map["BirthDate"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
          DistanceRadius <- map["DistanceRadius"]
          PerHourRate <- map["PerHourRate"]
          IsPerHourRatePublic  <- map["IsPerHourRatePublic"]
          PerDayRate  <- map["PerDayRate"]
          IsPerDayRatePublic <- map["IsPerDayRatePublic"]
          IsOwnVehicle <- map["IsOwnVehicle"]
          IsLicenceHeld <- map["IsLicenceHeld"]
          UserID <- map["UserID"]
          FullName <- map["FullName"]
          CompanyName <- map["CompanyName"]
          ProfileImageLink <- map["ProfileImageLink"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          TradeNameList <- map["TradeNameList"]
          SectorNameList <- map["SectorNameList"]
          ServiceNameList <- map["ServiceNameList"]
          ExperinceList <- map["ExperinceList"]
          CertificateList  <- map["CertificateList"]
          ActivityList <- map["ActivityList"]
          PortfolioList <- map["PortfolioList"]
          FollowerUserList <- map["FollowerUserList"]
          FollowingUserList <- map["FollowingUserList"]
     }
     func mapping(map: Map) {
          IsSaved <- map["IsSaved"]
          JobRoleName <- map["JobRoleName"]
          TotalFollower <- map["TotalFollower"]
          TotalFollowing <- map["TotalFollowing"]
          IsFollow <- map["IsFollow"]
          IsFollowing <- map["IsFollowing"]
          BirthDate  <- map["BirthDate"]
          IsEmailPublic <- map["IsEmailPublic"]
          IsPhonePublic <- map["IsPhonePublic"]
          IsMobilePublic <- map["IsMobilePublic"]
          MobileNumber <- map["MobileNumber"]
          PhoneNumber <- map["PhoneNumber"]
          CompanyEmailID <- map["CompanyEmailID"]
          Website <- map["Website"]
          DistanceRadius <- map["DistanceRadius"]
          PerHourRate <- map["PerHourRate"]
          IsPerHourRatePublic  <- map["IsPerHourRatePublic"]
          PerDayRate  <- map["PerDayRate"]
          IsPerDayRatePublic <- map["IsPerDayRatePublic"]
          IsOwnVehicle <- map["IsOwnVehicle"]
          IsLicenceHeld <- map["IsLicenceHeld"]
          UserID <- map["UserID"]
          FullName <- map["FullName"]
          CompanyName <- map["CompanyName"]
          ProfileImageLink <- map["ProfileImageLink"]
          TradeName <- map["TradeName"]
          CityName <- map["CityName"]
          DistanceAwayText <- map["DistanceAwayText"]
          Description <- map["Description"]
          TradeNameList <- map["TradeNameList"]
          SectorNameList <- map["SectorNameList"]
          ServiceNameList <- map["ServiceNameList"]
          ExperinceList <- map["ExperinceList"]
          CertificateList  <- map["CertificateList"]
          ActivityList <- map["ActivityList"]
          PortfolioList <- map["PortfolioList"]
          FollowerUserList <- map["FollowerUserList"]
          FollowingUserList <- map["FollowingUserList"]
     }
}


