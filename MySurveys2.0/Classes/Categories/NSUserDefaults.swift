//
//  NSUserDefaults.swift
//  MySurveys2.0
//
//  Created by Chinthan on 20/06/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation

extension UserDefaults {
    func colorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        else {
            color = UIColor(red: 247/255.0, green: 145/255.0, blue: 55/255.0, alpha: 1.0)
        }
        return color
    }
    
    func textColorForKey(_ key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        else {
            color = UIColor.white
        }
        return color
    }
    
    func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = UIImage(data: imageData)
        }
        return image
    }
    
    func setImage(_ image: UIImage?, forKey key: String) {
        var imageData: Data?
        if let image = UIImagePNGRepresentation(image!) {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image)
        }
        set(imageData, forKey: key)
    }
    
}
