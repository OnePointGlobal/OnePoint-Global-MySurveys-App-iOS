//
//  UIColor.swift
//  MySurveys2.0
//
//  Created by Chinthan on 20/06/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func appBGColor() -> UIColor {
        let defaults = UserDefaults.standard
        let bgColor = defaults.colorForKey("appBgColor")!
        return bgColor
    }

    class func appTextColor() -> UIColor {
        let defaults = UserDefaults.standard
        _ = defaults.integer(forKey: "Color")
        let bgColor = defaults.textColorForKey("textColor")!
        return bgColor
    }
    
    convenience init(hexString: String) {
        let hexString: NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
