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

class GetSignUp2: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : Results2 = Results2()
    
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
class Results2: NSObject, Mappable  {
    
    var DepartmentIdList:[Int] = []
     var SectorIdList:[Int] = []
     var JobRoleIdList:[Int] = []
     var TradeIdList:[Int] = []
     var JobRoleList : [JobRoleListM] = []
     var TradeSubtradeList : [SubTradeListM] = []
     var SubTradeIdList:[Int] = []
     var ServiceNameList:[String] = []
     var DistanceRadius = 0.0
     var Address = ""
     var CityName = ""
     var Postcode = ""
     var Latitude = 0.0
     var Longitude = 0.0
    override init()
    {
        
    }
    required init?(map: Map)
    {
        DepartmentIdList <- map["DepartmentIdList"]
        SectorIdList <- map["SectorIdList"]
        JobRoleIdList <- map["JobRoleIdList"]
        JobRoleList <- map["JobRoleList"]
        TradeIdList <- map["TradeIdList"]
        TradeSubtradeList <- map["TradeSubtradeList"]
        SubTradeIdList <- map["SubTradeIdList"]
        DistanceRadius <- map["DistanceRadius"]
        ServiceNameList <- map["ServiceNameList"]
        Address <- map["Address"]
        CityName <- map["CityName"]
        Postcode <- map["Postcode"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
    }
    func mapping(map: Map)
    {
        DepartmentIdList <- map["DepartmentIdList"]
        SectorIdList <- map["SectorIdList"]
        JobRoleIdList <- map["JobRoleIdList"]
        JobRoleList <- map["JobRoleList"]
        TradeIdList <- map["TradeIdList"]
        TradeSubtradeList <- map["TradeSubtradeList"]
        SubTradeIdList <- map["SubTradeIdList"]
        DistanceRadius <- map["DistanceRadius"]
        ServiceNameList <- map["ServiceNameList"]
        Address <- map["Address"]
        CityName <- map["CityName"]
        Postcode <- map["Postcode"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
    }
}
