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

class EditDetailJobDetail: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : EditJobResults = EditJobResults()
    
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

class EditJobResults: NSObject, Mappable  {

     var JobID = 0
     var JobRoleIdList:[Int] = []
     var SectorIdList:[Int] = []
     var TradeID = 0
     var CertificateIdList:[Int] = []
     var Description = ""
     var Location = ""
     var Latitude = 0.0
     var Longitude = 0.0
     var StartOn = ""
     var EndOn = ""

    override init()
    {
    
    }
    required init?(map: Map)
    {
        JobID <- map["JobID"]
        JobRoleIdList <- map["JobRoleIdList"]
        SectorIdList <- map["SectorIdList"]
        TradeID <- map["TradeID"]
        CertificateIdList <- map["CertificateIdList"]
        Description <- map["Description"]
        Location <- map["Location"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
    }
    func mapping(map: Map)
    {
        JobID <- map["JobID"]
        JobRoleIdList <- map["JobRoleIdList"]
        SectorIdList <- map["SectorIdList"]
        TradeID <- map["TradeID"]
        CertificateIdList <- map["CertificateIdList"]
        Description <- map["Description"]
        Location <- map["Location"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        StartOn <- map["StartOn"]
        EndOn <- map["EndOn"]
    }
}
