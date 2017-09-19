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

class GetSignUp1: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : Results1 = Results1()
    
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
class Results1: NSObject, Mappable  {
    
     var CertificateID = 0
     var ProfileImageLink = ""
     var IsPhonePublic = false
     var DateOfBirth = ""
     var PhoneNumber = ""
     var Website = ""
     var IsEmailPublic = false
     var MobileNumber = ""
     var IsMobilePublic = false
     var CompanyEmailAddress = ""
     var CompanyName = ""
     var Description = ""
    
    override init()
    {
        
    }
    required init?(map: Map){
        ProfileImageLink <- map["ProfileImageLink"]
        IsPhonePublic <- map["IsPhonePublic"]
        DateOfBirth <- map["DateOfBirth"]
        PhoneNumber <- map["PhoneNumber"]
        Website <- map["Website"]
        IsEmailPublic <- map["IsEmailPublic"]
        MobileNumber <- map["MobileNumber"]
        IsMobilePublic <- map["IsMobilePublic"]
        CompanyEmailAddress <- map["CompanyEmailAddress"]
        CompanyName <- map["CompanyName"]
        Description <- map["Description"]
    }
    func mapping(map: Map) {
        ProfileImageLink <- map["ProfileImageLink"]
        IsPhonePublic <- map["IsPhonePublic"]
        DateOfBirth <- map["DateOfBirth"]
        PhoneNumber <- map["PhoneNumber"]
        Website <- map["Website"]
        IsEmailPublic <- map["IsEmailPublic"]
        MobileNumber <- map["MobileNumber"]
        IsMobilePublic <- map["IsMobilePublic"]
        CompanyEmailAddress <- map["CompanyEmailAddress"]
        CompanyName <- map["CompanyName"]
        Description <- map["Description"]
    }
}
