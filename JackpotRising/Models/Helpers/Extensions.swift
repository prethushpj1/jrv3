//
//  NSDateExtension.swift
//  JackpotRising
//
//  Created by Prethush on 22/06/16.
//  Copyright © 2016 Jackpot Rising Inc. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


// MARK: - NSDate extension
internal extension Date{

    func convertToJRPayoutDateFormat() -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd,yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
    
    func convertToJRContestAPIFormat() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
    
    func add(minute minutes: Int) -> Date? {
        return (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: minutes, to: self, options: NSCalendar.Options.matchFirst)
    }
    
    func add(hour hours: Int) -> Date? {
        return (Calendar(identifier: Calendar.Identifier.gregorian) as NSCalendar).date(byAdding: NSCalendar.Unit.hour, value: hours, to: self, options: NSCalendar.Options.matchFirst)
    }
}

// MARK: - UIColor extension
internal extension UIColor{

    /**
     Converts the given HEX color string to UIColor object
     
     - parameter colorCode: HEX color stringq
     - parameter alpha:     alpha value
     
     - returns: UIColor object from given color code and alpha
     */
    class func colorFromHex(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
        
        let newColorCode = colorCode.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string:newColorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
}

internal extension UIView{
    
    func showActivityView() -> UIView{
        var heightRatio: CGFloat = 1.0 //heightRatio for iPad
        var overlayView = UIView(), activityView = UIView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if UIApplication.shared.statusBarOrientation.isPortrait {
                heightRatio = UIScreen.main.bounds.width / 414
            }
            else {
                heightRatio = UIScreen.main.bounds.height / 414
            }
        default:
            break
        }
        
        let window = UIApplication.shared.delegate?.window!!
        let baseLineView = window!.forBaselineLayout()
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        baseLineView.addSubview(overlayView)
        baseLineView.bringSubview(toFront: overlayView)
        
        let topConstraint = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: baseLineView, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: baseLineView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: overlayView, attribute: .trailing, relatedBy: .equal, toItem: baseLineView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: baseLineView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        activityView = UIView(frame: CGRect(x: 0, y: 0, width: 73 * heightRatio, height: 73 * heightRatio))
        overlayView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: activityView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 73 * heightRatio)
        let heightConstraint = NSLayoutConstraint(item: activityView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 73 * heightRatio)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityView.addSubview(imageView)
        
        let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: activityView, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: activityView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: activityView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: activityView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
//        imageView.image = UIImage(named: "ActivityIndicator", in: Bundle(for: BaseController.self), compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        
        for layer in activityView.layer.sublayers! {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        
        var progressCircle = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: /*CGPoint(x: 0, y: 0)*/CGPoint(x: activityView.bounds.midX, y: activityView.bounds.midY), radius: (activityView.bounds.width / 2) - 4, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        progressCircle = CAShapeLayer ()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.colorFromHex("CA2225", alpha: 0.9).cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 5//self.loader.bounds.width / 2
        
        activityView.layer.addSublayer(progressCircle)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = false
        animation.repeatCount = 50
        
        progressCircle.add(animation, forKey: "customAnimation")
        for subView in activityView.subviews {
            if subView.isKind(of: UIImageView.self) {
                activityView.bringSubview(toFront: subView)
            }
        }
        
        return overlayView
    }
}

internal extension String{
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                                                options: .caseInsensitive)
            return regex.firstMatch(in: self,
                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                            range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func convertToDictionary() -> [String:AnyObject]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            
            do {
                return try JSONSerialization.jsonObject(with: data,
                                                           options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                
            } catch let error as NSError {
                print(error)
            }
        }
        return ["":"" as AnyObject]
    }
    
    func getMD5Hash() -> String {
        return NSString(string: self).mD5Hash()
        
    }
    
    func convertToRegularDateObject() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let timeZoneSeconds = TimeZone.ReferenceType.local.secondsFromGMT()
        return dateFormatter.date(from: self)?.addingTimeInterval(TimeInterval(timeZoneSeconds))
    }
    
    func getParametersFromQueryString() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
        let scanner = Scanner(string: self)
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanString("=", into: nil)
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanString("&", into: nil)
        
            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        return parameters
    }
    
    func stripWhiteSpace() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func containsOnlyDigits() -> Bool
    {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        
        if rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
        {
            return true
        }
        
        return false
    }
    
    func capitalizedFirstLetter() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased(with: Locale.current) + rest.lowercased(with: Locale.current)
    }
    
    func capitalizeLetters(letters: String) -> String{
        let rangeofString = self.lowercased().range(of: letters.lowercased())
        if let range = rangeofString{
            let capitalized = self.substring(with: range).uppercased()
            
            let firstRange = Range(uncheckedBounds: (lower: self.startIndex, upper: range.lowerBound))
            let first = self.substring(with: firstRange)
            
            let secondRange = Range(uncheckedBounds: (lower: range.upperBound, upper: self.endIndex))
            let second = self.substring(with: secondRange)
            return first + capitalized + second
        }
        return self
    }
    
    func substringTill(Index to: Int) -> String {
        if to > self.characters.count{
            return self
        }
        
        let index = self.index(self.startIndex, offsetBy: to)
        return self.substring(to: index)
    }
    
    subscript (i: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: i)
        return "\(self[index])"
    }
    
    /**
     Calculate remainig time for the given date and returns in words
     
     - parameter dateString: date in String to calculate the remaining time
     
     - returns: remaining time for given date in words
     */
    func remainingTimeInStringFromDate() -> String{
        
        let rfc3339DateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale.init(identifier: "en_US_POSIX")
        
        rfc3339DateFormatter.locale = enUSPOSIXLocale
        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        rfc3339DateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        
        // Convert the RFC 3339 date time string to an NSDate.
        let date2  = rfc3339DateFormatter.date(from: self)
        
        let secondsBetween = date2?.timeIntervalSince(Date())
        
        var finalDifference = ""
        
        if secondsBetween < 1 || secondsBetween == 0 {
            finalDifference = ""
        }
        else{
            let day = Int(secondsBetween! / (60*60*24))
            let rem1  = fmod(secondsBetween!, (60*60*24))
            let hour = Int(rem1 / (60*60))
            let rem2 = Int(fmod(rem1, (60*60)))
            let min = Int(rem2 / 60)
            
            finalDifference = "\(day < 1 ? "" : "\(day)day(s) : ")\(hour < 1 ? "" : "\(hour)hour(s) : ")\(min < 1 ? "" : "\(min)minute(s)") is remaining"
        }
        
        return finalDifference
    }
    
    func contestStartTimeInStringFromDate() -> String{
        
        let rfc3339DateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale.init(identifier: "en_US_POSIX")
        
        rfc3339DateFormatter.locale = enUSPOSIXLocale
        rfc3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        rfc3339DateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        
        // Convert the RFC 3339 date time string to an NSDate.
        let date2  = rfc3339DateFormatter.date(from: self)
        
        let secondsBetween = date2?.timeIntervalSince(Date())
        
        var finalDifference = ""
        
        if secondsBetween < 1 || secondsBetween == 0 {
            finalDifference = ""
        }
        else{
            let day = Int(secondsBetween! / (60*60*24))
            let rem1  = fmod(secondsBetween!, (60*60*24))
            let hour = Int(rem1 / (60*60))
            let rem2 = Int(fmod(rem1, (60*60)))
            let min = Int(rem2 / 60)
            
            finalDifference = "Starts in \(day < 1 ? "" : "\(day)day(s) : ")\(hour < 1 ? "" : "\(hour)hour(s) : ")\(min < 1 ? "" : "\(min)minute(s)")"
        }
        
        return finalDifference
    }
}

internal extension UITextField {
    //to set padding to textfield
    func setPaddingtoTextField (direction: Directions) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        switch direction {
        case Directions.Left:
            self.leftView = paddingView
            self.leftViewMode = .always
        case Directions.Right:
            self.leftView = paddingView
            self.rightView = paddingView
            self.rightViewMode = .always
            self.leftViewMode = .always
        default:
            break
        }
    }
    
    /* validate email ID */
    func isValidEmail() -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailValidate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailValidate.evaluate(with: self.text!)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToTwoPlaces() -> Double {
        return Double(floor(pow(10.0, Double(2)) * self)/pow(10.0, Double(2)))
    }
    
    func roundToPlacesAsString(_ places:Int) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func getDecimal(Places places:Int) -> Double{
        let powerOfTen:Double = pow(10.0, Double(places))
        let places = (self.truncatingRemainder(dividingBy: 1.0) * powerOfTen).rounded() / powerOfTen
        return places
    }
    
    //US currency formatter
    func usCurrencyFormatString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int {
    
    //US currency formatter
    func usCurrencyFormatStringWithoutDecimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        var str = formatter.string(from: NSNumber(value: self)) ?? ""
        str = str.replacingOccurrences(of: ".00", with: "")
        return str.replacingOccurrences(of: "$", with: "")
    }
}

extension UILabel {
    
    func isTruncated() -> Bool {
        
        if let string = self.text {
            
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil).size
            return (size.width > self.bounds.size.width)
        }
        
        return false
    }
}
