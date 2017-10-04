//
//  UIImage.swift
//  MySurveys2.0
//
//  Created by Chinthan on 22/06/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation
extension UIImage{
    
    class func appBGImage() -> UIImage? {
        let defaults = UserDefaults.standard
        let bgImage = defaults.object(forKey: "bgImage")
        var image: UIImage?
        if bgImage != nil {
            image = UIImage(data: bgImage as! Data)!

        }        
        return image
    }
}
