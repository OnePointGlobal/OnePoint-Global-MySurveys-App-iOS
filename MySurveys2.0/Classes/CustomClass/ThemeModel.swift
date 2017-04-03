//
//  ThemeModel.swift
//  MySurveys2.0
//
//  Created by Manjunath on 14/02/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

import UIKit

class ThemeModel: NSObject
{
    var actionBtn: String?
    var headerLogo: String?
    var linksColor: String?
    var loginBackground: String?
    var logoText: String?


    init(actionBtn: String?,headerLogo: String?,linksColor: String?, loginBackground: String?,logoText: String?){
        self.actionBtn = actionBtn
        self.headerLogo = headerLogo
        self.linksColor = linksColor
        self.loginBackground = loginBackground
        self.logoText = logoText
    }

}
