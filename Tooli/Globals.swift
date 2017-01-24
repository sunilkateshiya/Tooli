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
    var deviceToken : String!
    var currentUser : SignIn!
    var masters : Masters!
    
    private init() {

        
    }
}
