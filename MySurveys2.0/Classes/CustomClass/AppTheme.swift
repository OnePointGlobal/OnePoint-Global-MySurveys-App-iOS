//
//  AppTheme.swift
//  MySurveys2.0
//
//  Created by Manjunath on 15/02/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

import UIKit

let EMPTY_STRING = ""

protocol LogoImageDownloadDelegate : class {    // 'class' means only class types can implement it
  func logoImageDidDownload()
}

class AppTheme: NSObject {
    static var delelgate: LogoImageDownloadDelegate? = nil
    static var theme: ThemeModel?
    static func initThemeModel(theme: NSDictionary) -> ThemeModel? {
        let actionBtn: String? = theme.value(forKey: "Actionbtn") as! String?
        let headerLogo: String? =  theme.value(forKey: "Headerlogo") as! String?
        let linksColor: String? =  theme.value(forKey: "Linkscolor") as! String?
        let loginBackground: String? =  theme.value(forKey: "Loginbackground") as! String?
        let logoText: String? =  theme.value(forKey: "Logotext") as! String?
        if headerLogo == nil || loginBackground == nil {
            // fix for wrong keys coming in theme dict when someone creates theme in old adminsuite wrongly
            return nil
        }
        else {
            let newTheme = ThemeModel(actionBtn: actionBtn, headerLogo: headerLogo, linksColor: linksColor, loginBackground: loginBackground, logoText: logoText)
            return newTheme
        }
    }

    /* !
     This method downloads media(image) for a particular theme when the panel is changed.
     */
    static func downloadThemeImage(mediaId: String, isLoginBGImage: Bool, fileName: String) {
        DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                var mediaObj: OPGDownloadMedia?
                do {
                    mediaObj  = try sdk.downloadMediaFile(mediaId, mediaType: "jpg", fileName: fileName) as OPGDownloadMedia
                    DispatchQueue.main.async {
                            if mediaObj?.isSuccess == 1 {
                                if mediaObj!.mediaFilePath != nil {
                                    if isLoginBGImage {
                                        self.setLoginBGImagePath(path: (mediaObj?.mediaFilePath)!)
                                    }
                                    else {
                                        self.setHeaderLogoImagePath(path: (mediaObj?.mediaFilePath)!)
                                        delelgate?.logoImageDidDownload()
                                    }
                                }
                            }
                    }
                }
                catch let err as NSError
                {
                    print("Error: \(err)")
                }
        }
    }

    /* !
     This method is called to set the new theme after a panel is changed.
     */
    static func setCurrentTheme(theme: NSDictionary) {
        if theme.count > 0 {
            let keys = theme.allKeys
            if keys.count == 5 {
                // Construct theme object
                self.theme = self.initThemeModel(theme: theme)
                let panelName = UserDefaults.standard.value(forKey: "SelectedPanelName") as? String
                if self.theme != nil {             // fix for wrong keys coming in theme dict when someone creates theme in old adminsuite wrongly
                    if let headerLogo = self.theme?.headerLogo {
                        if Int(headerLogo)! > 0 {
                            self.downloadThemeImage(mediaId: headerLogo, isLoginBGImage: false, fileName: (panelName?.appending("ThemeHeaderLogo"))!)
                        }
                        else {
                            self.setHeaderLogoImagePath(path: EMPTY_STRING)
                        }
                    }

                    if let loginBgMediaId = self.theme?.loginBackground {
                        if Int(loginBgMediaId)!>0 {
                            self.downloadThemeImage(mediaId: loginBgMediaId, isLoginBGImage: true, fileName: (panelName?.appending("ThemeLoginBG"))!)
                        }
                        else {
                            self.setLoginBGImagePath(path: EMPTY_STRING)
                        }
                    }

                    if let logoText = self.theme?.logoText {
                        self.setLogoText(text: logoText)
                    }
                    else {
                        self.setLogoText(text: EMPTY_STRING)
                    }
                }
                else {
                    self.setLoginBGImagePath(path: EMPTY_STRING)                // defaultBG image
                    self.setHeaderLogoImagePath(path: EMPTY_STRING)        // default header logo image
                    self.setLogoText(text: EMPTY_STRING)
                }
            }
            else if keys.count == 15 {
               // Old adminsuite theme
               self.setDefaultThemeProperties()
            }
        }
        else {
            // no theme is set for panel in new adminsuite so set default theme
            self.setDefaultThemeProperties()
        }
    }


    // MARK: - Private methods
    // Creates a UIColor from a Hex string.
    static func colorWithHexString (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.characters.count != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    static func setDefaultThemeProperties() {
        self.setLoginBGImagePath(path: EMPTY_STRING)                // defaultBG image
        self.setHeaderLogoImagePath(path: EMPTY_STRING)        // default header logo image
        self.setLogoText(text: EMPTY_STRING)
        self.theme = nil                                        // no theme
    }

    // MARK: - Getter/Setter methods
    static func appBackgroundColor() -> UIColor {
        if self.theme == nil {
            return UIColor.appBGColor()                 // default color
        }
        else {
            return self.colorWithHexString(hex: (self.theme?.actionBtn)!)
        }
    }

    static func getLoginBGImagePath() -> String {
        let bgImagePath: String? = UserDefaults.standard.value(forKey: "LoginBGImagePath") as? String
        if bgImagePath==nil || (bgImagePath?.isEmpty)! {
            return EMPTY_STRING
        }
        else {
            // UDID of the device tmp folder path changes on every re-run
            let filePath: String? = UserDefaults.standard.value(forKey: "LoginBGImagePath") as? String
            let filePathWithoutSpaces = filePath?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let filename =  NSURL(string: filePathWithoutSpaces!)?.lastPathComponent
            let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename!)        // get image name, construct path and return
            return (tempDirURL?.path)!
        }
    }

    static func setLoginBGImagePath(path: String) {
        UserDefaults.standard.set(path, forKey: "LoginBGImagePath")
    }

    static func getHeaderLogoImagePath() -> String {
        let headerImgPath: String? = UserDefaults.standard.value(forKey: "HeaderLogoImagePath") as? String
        if headerImgPath==nil || (headerImgPath?.isEmpty)! {
            return EMPTY_STRING
        }
        else {
            // UDID of the device tmp folder path changes on every re-run
            let filePath = (UserDefaults.standard.object(forKey: "HeaderLogoImagePath") as? String)!
            let filePathWithoutSpaces = filePath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let filename =  NSURL(string: filePathWithoutSpaces!)?.lastPathComponent
            let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename!)        // get image name, construct path and return
            return (tempDirURL?.path)!
        }
    }

    static func setHeaderLogoImagePath(path: String) {
        UserDefaults.standard.set(path, forKey: "HeaderLogoImagePath")
    }

    static func getLoginBtnTextColor() -> UIColor {
        return UserDefaults.standard.colorForKey("LoginBtnTextColor")!
    }

    static func setLoginBtnTextColor(color: UIColor) {
        UserDefaults.standard.setColor(color, forKey: "LoginBtnTextColor")
    }

    static func setLogoText(text: String) {
        UserDefaults.standard.set(text, forKey: "ThemeLogoText")
    }

    static func getLogoText() -> String {
        let logoText = UserDefaults.standard.value(forKey: "ThemeLogoText") as? String
        if logoText != nil {
            return logoText!
        }
        return EMPTY_STRING
    }

}
