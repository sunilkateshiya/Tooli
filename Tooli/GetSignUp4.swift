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

class GetSignUp4: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : Results4 = Results4()
    
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

class Results4: NSObject, Mappable  {

     var PerHourRate = ""
     var PerDayRate = ""
     var IsPerHourRatePublic:Bool = false
     var IsPerDayRatePublic:Bool = false
     var IsOwnVehicle:Bool = false
     var IsLicenceHeld:Bool = false

    override init()
    {
        
    }
    required init?(map: Map){
        PerHourRate <- map["PerHourRate"]
        PerDayRate <- map["PerDayRate"]
        IsPerHourRatePublic <- map["IsPerHourRatePublic"]
        IsPerDayRatePublic <- map["IsPerDayRatePublic"]
        IsOwnVehicle <- map["IsOwnVehicle"]
        IsLicenceHeld <- map["IsLicenceHeld"]
    }
    func mapping(map: Map) {
        PerHourRate <- map["PerHourRate"]
        PerDayRate <- map["PerDayRate"]
        IsPerHourRatePublic <- map["IsPerHourRatePublic"]
        IsPerDayRatePublic <- map["IsPerDayRatePublic"]
        IsOwnVehicle <- map["IsOwnVehicle"]
        IsLicenceHeld <- map["IsLicenceHeld"]
    }
}
