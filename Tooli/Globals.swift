//
//  Globals.swift
//  BlueCoupon
//
//  Created by Impero IT on 03/06/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
class Globals {
    static let sharedInstance = Globals()
<<<<<<< HEAD
    var deviceToken : String = ""
    var currentUser : UserDataM = UserDataM()
=======
    var deviceToken : String!
    var currentUser : SignIn!
    var masters : Masters!
    var selectedCompany : CompanyProfileM!
    var dashBoard : ContractorDashBoard!
    var SearchdashBoard : SearchContractoreList!
    var jobList : JobList!
    var connectionList : ConnectionList!
    var OfferDetail : OfferListM!
    var OfferDetail1 : OfferDetailM!
    var savedPageList:SavedPageList!
    var portFolio:Portfolio!
    var stastics:StatisticsModal!
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
    var unreadAllNotification:Int = 0
    var unreadMessage:Int = 0
    var unreadBuddyGroup:Int = 0
    var unreadOfferNotification:Int = 0
        
    private init()
    {

        
    }
    class func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
        
        let originalSize = original.size
        var newSize = originalSize
        
        if originalSize.width > widthLimit && originalSize.width > originalSize.height {
            
            newSize.width = widthLimit
            newSize.height = originalSize.height*(widthLimit/originalSize.width)
        }else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
            
            newSize.width = 800
            newSize.height = originalSize.height*(widthLimit/originalSize.width)
        }
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        
        original.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return compressedImage!
    }
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
<<<<<<< HEAD
                 
=======
                print(error.localizedDescription)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
        }
        return nil
    }
}
