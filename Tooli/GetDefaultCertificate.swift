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

class GetDefaultCertificate: NSObject, Mappable  {
    
    var Status = 0
    var Message = ""
    var Result : [DefualtCertificateM] = []
    
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
class DefualtCertificateM: NSObject, Mappable
{
    
    var CertificateID = 0
    var CertificateName = ""
    var FileType = ""
    var CertificateFileLink = ""
    override init()
    {
        
    }
    required init?(map: Map){
        CertificateID <- map["CertificateID"]
        CertificateName <- map["CertificateName"]
        FileType <- map["FileType"]
        CertificateFileLink <- map["CertificateFileLink"]
    }
    func mapping(map: Map) {
        CertificateID <- map["CertificateID"]
        CertificateName <- map["CertificateName"]
        FileType <- map["FileType"]
        CertificateFileLink <- map["CertificateFileLink"]
    }
}
