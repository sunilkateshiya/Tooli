//
//  File.swift
//  Tooli
//
//  Created by Impero IT on 10/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import Foundation

import UIKit
import ObjectMapper

class GetDefaultList: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : ResultList = ResultList()
    
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

class ResultList: NSObject, Mappable  {
    
    var DepartmentList : [DepartmentListM] = []
    var JobRoleList:[JobRoleListM] = []
    var SectorList : [SectorListM] = []
    var TradeList : [TradeListM] = []
    var SerachTradeList : [SubTradeListM] = []
    var SubTradeList:[SubTradeListM] = []
    var TradeDefaultList:[SubTradeListM] = []
    var CertificateList:[CertificateM] = []
    override init()
    {
        
    }
    required init?(map: Map){
        DepartmentList <- map["DepartmentList"]
        JobRoleList <- map["JobRoleList"]
        SectorList <- map["SectorList"]
        TradeList <- map["TradeList"]
        TradeDefaultList <- map["TradeDefaultList"]
        SerachTradeList <- map["TradeDefaultList"]
        SubTradeList <- map["SubTradeList"]
        CertificateList <- map["CertificateList"]
    }
    func mapping(map: Map) {
        DepartmentList <- map["DepartmentList"]
        JobRoleList <- map["JobRoleList"]
        SectorList <- map["SectorList"]
        TradeList <- map["TradeList"]
        TradeDefaultList <- map["TradeDefaultList"]
        SerachTradeList <- map["TradeDefaultList"]
        CertificateList <- map["CertificateList"]
    }
}
class DepartmentListM: NSObject, Mappable
{
    var DepartmentID = 0
    var DepartmentName = ""
    var JobRoleList:[JobRoleListM] = []
    override init()
    {
        
    }
    required init?(map: Map){
        DepartmentID <- map["DepartmentID"]
        DepartmentName <- map["DepartmentName"]
        JobRoleList <- map["JobRoleList"]
    }
    func mapping(map: Map) {
        DepartmentID <- map["DepartmentID"]
        DepartmentName <- map["DepartmentName"]
        JobRoleList <- map["JobRoleList"]
    }
}
class SectorListM: NSObject, Mappable  {
    
    var SectorID = 0
    var SectorName = ""
    
    override init()
    {
        
    }
    required init?(map: Map){
        SectorID <- map["SectorID"]
        SectorName <- map["SectorName"]
    }
    func mapping(map: Map) {
        SectorID <- map["SectorID"]
        SectorName <- map["SectorName"]
    }
}
class TradeListM: NSObject, Mappable
{
    var TradeID = 0
    var TradeName = ""
    var SubTradeList:[SubTradeListM] = []
    
    override init()
    {
        
    }
    required init?(map: Map){
        TradeID <- map["TradeID"]
        TradeName <- map["TradeName"]
        SubTradeList <- map["SubTradeList"]
    }
    func mapping(map: Map) {
        TradeID <- map["TradeID"]
        TradeName <- map["TradeName"]
        SubTradeList <- map["SubTradeList"]
    }
}

class SubTradeListM: NSObject, Mappable
{
    var Id = 0
    var Name = ""
    var IsTrade:Bool = true
    override init()
    {
        
    }
    required init?(map: Map){
        Id <- map["Id"]
        Name <- map["Name"]
        IsTrade <- map["IsTrade"]
    }
    func mapping(map: Map) {
        Id <- map["Id"]
        Name <- map["Name"]
        IsTrade <- map["IsTrade"]
    }
}

class JobRoleListM: NSObject, Mappable
{
    var DepartmentID = 0
    var JobRoleName = ""
    var JobRoleID = 0
    override init()
    {
        
    }
    required init?(map: Map){
        DepartmentID <- map["DepartmentID"]
        JobRoleName <- map["JobRoleName"]
        JobRoleID <- map["JobRoleID"]
    }
    func mapping(map: Map) {
        DepartmentID <- map["DepartmentID"]
        JobRoleName <- map["JobRoleName"]
        JobRoleID <- map["JobRoleID"]
    }
}
