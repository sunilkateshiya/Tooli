//
//  CALayer.swift
//
//  Created by Ben Dodson - http://bendodson.com/
//

import UIKit
import QuartzCore

extension CALayer {
    
    func setIBShadowColor(color: UIColor) {
        shadowColor = color.cgColor
    }
    
    func setIBBorderColor(color: UIColor) {
        borderColor = color.cgColor
    }
    
}
