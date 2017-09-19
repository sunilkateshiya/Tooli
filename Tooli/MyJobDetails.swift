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

class MyJobDetails: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : JobDetailsWithApplicant = JobDetailsWithApplicant()
    
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
class JobDetailsWithApplicant: NSObject, Mappable
{
    var JobApplicantList : [ApplicantM] = []
    var JobView : JobViewM = JobViewM()
    override init()
    {
        
    }
    required init?(map: Map){
        JobApplicantList <- map["JobApplicantList"]
        JobView <- map["JobView"]
    }
    func mapping(map: Map) {
        JobApplicantList <- map["JobApplicantList"]
        JobView <- map["JobView"]
    }
}
class ApplicantM: NSObject, Mappable
{
    var DepartmentName = ""
    var TotalFollower = 0
    var TotalFollowing = 0
    var UserID = ""
    var FullName = ""
    var CompanyName = ""
    var ProfileImageLink = ""
    var TradeName = ""
    var CityName = ""
    var Message = ""
    var DistanceAwayText = ""
    var Description = ""
    var IsSaved = false
    var ReferralCode = ""
    var Role = 0
    
    override init()
    {
        
    }
    required init?(map: Map){
        DepartmentName <- map["DepartmentName"]
        TotalFollower <- map["TotalFollower"]
        TotalFollowing <- map["TotalFollowing"]
        UserID <- map["UserID"]
        FullName <- map["FullName"]
        CompanyName <- map["CompanyName"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeName <- map["TradeName"]
        CityName <- map["CityName"]
        Message <- map["Message"]
        DistanceAwayText <- map["DistanceAwayText"]
        Description <- map["Description"]
        IsSaved <- map["IsSaved"]
        ReferralCode <- map["ReferralCode"]
        Role <- map["Role"]
        
    }
    func mapping(map: Map) {
        DepartmentName <- map["DepartmentName"]
        TotalFollower <- map["TotalFollower"]
        TotalFollowing <- map["TotalFollowing"]
        UserID <- map["UserID"]
        FullName <- map["FullName"]
        CompanyName <- map["CompanyName"]
        ProfileImageLink <- map["ProfileImageLink"]
        TradeName <- map["TradeName"]
        CityName <- map["CityName"]
        Message <- map["Message"]
        DistanceAwayText <- map["DistanceAwayText"]
        Description <- map["Description"]
        IsSaved <- map["IsSaved"]
        ReferralCode <- map["ReferralCode"]
        Role <- map["Role"]
    }
}
