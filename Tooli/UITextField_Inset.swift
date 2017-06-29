//
//  UITextField + Inset.swift
//  SMUJ
//
//  Created by Moin Shirazi on 23/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit

@IBDesignable
class UITextField_Inset: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
}
