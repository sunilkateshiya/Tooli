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

class GetCertificateList: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : [CertificateM] = []
    
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
class CertificateM: NSObject, Mappable  {
    
    var CertificateID = 0
    var CertificateName = ""
    override init()
    {
        
    }
    required init?(map: Map){
        CertificateID <- map["CertificateID"]
        CertificateName <- map["CertificateName"]
    }
    func mapping(map: Map) {
        CertificateID <- map["CertificateID"]
        CertificateName <- map["CertificateName"]
    }
}
