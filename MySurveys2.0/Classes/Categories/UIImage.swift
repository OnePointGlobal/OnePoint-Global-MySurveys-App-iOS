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
    
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 0.8
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue = compressingValue * 0.8
                }
            }
        }
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
