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

class GetSignUp3: NSObject, Mappable
{
    var Status = 0
    var Message = ""
    var Result : [ExperienceM] = []
    
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
class ExperienceM: NSObject, Mappable  {

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
