//
//  BTextField.swift
//  BlueCoupon
//
//  Created by Impero IT on 03/06/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit

extension UITextView {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+6)
        }
    }
}

extension UITextField {
    open override func awakeFromNib() {
//        self.attributedPlaceholder = NSAttributedString(string:self.placeholder!,
//                                                        attributes:[NSForegroundColorAttributeName: Constants.THEME.TEXT_COLOR])
//        self.textColor=Constants.THEME.TEXT_COLOR
        
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+6)
        }
        
    }
}

extension String {
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return dateFormatter.date(from: self)!
    }
    func heightWithWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
        return actualSize.height
    }
    func WidfthWithHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
        return actualSize.width
    }
}

extension NSAttributedString {
    func heightWithWidth(width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}
extension NSMutableAttributedString {
    
    //    func setColorForStr(textToFind: String, color: UIColor) {
    //
    //        let range = self.mutableString.rangeOfString(textToFind, options:NSString.CompareOptions.CaseInsensitiveSearch);
    //        if range.location != NSNotFound {
    //            self.addAttribute(NSForegroundColorAttributeName, value: color, range: range);
    //        }
    //
    //    }
}
extension UILabel {
    func heightWithWidth(width: CGFloat) -> CGFloat {
        guard let text = text else {
            return 0
        }
        return text.heightWithWidth(width: width, font: font)
    }
    
    func heightWithAttributedWidth(width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.heightWithWidth(width: width)
    }
}

extension UILabel {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+6)
        }
    }
    func setUnderLineToLabel(strText:String)
    {
        self.isUserInteractionEnabled = true
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: strText, attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
}
extension UIButton {
    func addBorder(){
        self.layer.borderColor = Constants.THEME.BUTTON_COLOR.cgColor
        self.layer.borderWidth = 1
    }
    
    override func addDashedBorder() {
        let color = Constants.THEME.TEXT_COLOR.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 2).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    open override func awakeFromNib() {
        
        
        
        if Constants.DeviceType.IS_IPHONE_5 {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!-1)
        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+3)
        }
        else if Constants.DeviceType.IS_IPAD {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+7)
        }
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}
extension String {
    var length: Int {
        return (self as NSString).length
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        // view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    func imageWithGradient() -> UIImage{
        let img = self
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.50, 1.0]
        //1 = opaque
        //0 = transparent
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top,bottom
            ] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors, locations: locations)
        
        
        let startPoint = CGPoint(x: img.size.width/2,y: 0)
        let endPoint = CGPoint(x: img.size.width/2,y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image!
        
    }
}

extension UIViewController {
    public func showAlert(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, alertActions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension Date {
    func toWebString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    func toDisplayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
extension Dictionary
{
    public init(keys: [Key], values: [Value])
    {
        precondition(keys.count == values.count)
        
        self.init()
        
        for (index, key) in keys.enumerated()
        {
            self[key] = values[index]
        }
    }
}
//extension NSDate {
//    func yearsFrom(date: NSDate) -> Int {
//        return NSCalendar.currentCalendar.components(.Year, fromDate: date, toDate: self, options: []).year
//    }
//    func monthsFrom(date: NSDate) -> Int {
//        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
//    }
//    func weeksFrom(date: NSDate) -> Int {
//        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
//    }
//    func daysFrom(date: NSDate) -> Int {
//        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
//    }
//    func hoursFrom(date: NSDate) -> Int {
//        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
//    }
//    func minutesFrom(date: NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
//    }
//    func secondsFrom(date: NSDate) -> Int{
//        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
//    }
//    func offsetFrom(date: NSDate) -> String {
//        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
//        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
//        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
//        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
//        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
//        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
//        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
//        return ""
//    }
//    func offsetFrom1(date:NSDate) -> String {
//
//        let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
//        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: self, options: [])
//
//        let seconds = "\(difference.second)"
//        let minutes = "\(difference.minute):" + "" + seconds
//        let hours = "\(difference.hour):" + "" + minutes
//        let days = "\(difference.day)d" + " " + hours
//
//        if difference.day    > 0 { return days }
//        if difference.hour   > 0 { return hours }
//        if difference.minute > 0 { return minutes }
//        if difference.second > 0 { return seconds }
//        return ""
//    }
//
//}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.red.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}

