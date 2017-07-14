//
//  LoginViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 08/06/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: RootViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    // MARK: - IBOutlets for view
    @IBOutlet weak var imgLogo: UIImageView?
    @IBOutlet weak var lblLogoText: UILabel?
    @IBOutlet weak var imgLoginBG: UIImageView?
    @IBOutlet weak var imgApp: UIImageView?
    @IBOutlet weak var imgSeparator: UIImage?
    @IBOutlet weak var txtUsername: UITextField?
    @IBOutlet weak var txtPassword: UITextField?
    @IBOutlet weak var lblGlobalAppNameText: UILabel?
    @IBOutlet weak var btnLogin: UIButton?
    @IBOutlet weak var btnForgotPassword: UIButton?
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var btnGooglePlusLogin: UIButton!
    @IBOutlet weak var constraintLoginViewCentre: NSLayoutConstraint!
    @IBOutlet weak var constraintImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var constarintForgotPassowrdTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var constraintLogoText: NSLayoutConstraint!
    @IBOutlet weak var constraintLogoImage: NSLayoutConstraint!
    // MARK: - Properties for viewcontroller
    var loginManager: FBSDKLoginManager?
    var bgColor: UIColor?

    // MARK: - IBOutlet Action methods
    @IBAction func loginAction(_ sender: UIButton) {
        if self.txtUsername?.text == nil ||  self.txtUsername?.text == "" {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Username/password cannot be empty.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
        } else if txtPassword?.text == nil ||  txtPassword?.text == "" {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Username/password cannot be empty.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
        } else {
            if super.isOnline() {
                self.startActivityIndicator()
                self.authenticate()
            } else {
                super.showNoInternetConnectionAlert()
            }
        }
    }

    @IBAction func forgotPasswordAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "embedForgot", sender: self)
    }

    @IBAction func googleSignInAction(_ sender: AnyObject) {
        if super.isOnline() {
            GIDSignIn.sharedInstance().signIn()
        }
        else {
            super.showNoInternetConnectionAlert()
        }
    }
    
    @IBAction func facebookLoginAction(_ sender: AnyObject) {
        if super.isOnline() == false {
            super.showNoInternetConnectionAlert()
            return
        }
        self.startActivityIndicator()

        self.loginManager?.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if error != nil {
                print("Custom facebook login failed ", error!)
                self.stopActivityIndicator()
                return
            }
            if result?.token != nil {
                self.authenticateWithFacebook(result: result!)
            }
            else {
                self.stopActivityIndicator()
                if super.isOnline() == false {
                    super.showNoInternetConnectionAlert()

                }
                else {
                    // token is nil even if the device is online
                    // incorrect username and password is handled by facebook itself on the webpage.
                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Can't sign in. Try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                }
            }
        }
    }

    // MARK: - View delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Login", comment: "")
        self.loginManager = FBSDKLoginManager()
        self.setBackgroundImageforView()
        self.stopActivityIndicator()
        self.txtUsername?.delegate = self
        self.txtPassword?.delegate = self
        self.txtUsername?.inputAccessoryView = self.hideKeyboard()
        self.txtPassword?.inputAccessoryView = self.hideKeyboard()
        self.txtUsername?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Username/EmailID", comment: "Username/EmailID"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.txtPassword?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Password", comment: "Password"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.btnLogin?.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
        self.btnLogin?.layer.borderColor = UIColor.white.cgColor
        self.btnLogin?.layer.borderWidth = 1.0

        self.btnLogin?.setTitle(NSLocalizedString("Login", comment: ""), for: UIControlState.normal)
        self.btnGooglePlusLogin.setTitle(NSLocalizedString("Sign in with Google", comment: ""), for: UIControlState.normal)
        self.btnFacebookLogin.setTitle(NSLocalizedString("Login with Facebook", comment: ""), for: UIControlState.normal)
        self.btnForgotPassword?.setTitle(NSLocalizedString("Forgot Password?", comment: ""), for: UIControlState.normal)
        // Configure GGLContext and set delegate
        GIDSignIn.sharedInstance().uiDelegate=self  // Google SignIn UI Delegate
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        // self.stopActivityIndicator()
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = AppTheme.appBackgroundColor()
        let defaults = UserDefaults.standard
        let name: String? = defaults.value(forKey: "appName") as? String
        if name != nil {
            lblGlobalAppNameText?.text = name
        }
        self.setThemeElements()
        self.checkForLogoImgAndText()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.txtUsername?.text = ""
        self.txtPassword?.text = ""
        self.txtPassword?.resignFirstResponder()
        self.txtUsername?.resignFirstResponder()
        AppTheme.theme=nil              // reset theme after showing custom BG image
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if AppTheme.getLoginBGImagePath().isEmpty {
            imgLoginBG?.alpha = 0.5
        }

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.setThemeElements()
            self.imgLoginBG?.alpha = 1.0
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            if self.constarintForgotPassowrdTrailingSpace != nil { // temp fix
                if width == OPGConstants.device.iPadLandscapeWidth || width == OPGConstants.device.iPadRetinaLandscapeWidth {
                    // iPad landscape
                    self.constarintForgotPassowrdTrailingSpace.constant = 250
                }
                else {
                    // iPad portrait
                    self.constarintForgotPassowrdTrailingSpace.constant = 120
                }
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        // iOS - CONSTARINTS CANNOT BE UPDATED FROM VIEWDIDLOAD()
        if  UIDevice.current.userInterfaceIdiom == .pad {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            if width == OPGConstants.device.iPadLandscapeWidth || width == OPGConstants.device.iPadRetinaLandscapeWidth {
                // iPad landscape
                self.constarintForgotPassowrdTrailingSpace.constant = 250
            }
        }
    }

    // MARK: - Generic Private methods
    func authenticate() {
        self.startActivityIndicator()    // start indicator when "Go" is pressed on keyboard
        self.setLoginControls(isInteractionEnabled: false)
        DispatchQueue.global(qos: .default).async {
            let sdk = OPGSDK()
            var authenticate: OPGAuthenticate
            do {
                authenticate = try sdk.authenticate(self.txtUsername?.text, password: self.txtPassword?.text) as OPGAuthenticate
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.setLoginControls(isInteractionEnabled: true)
                    if authenticate.isSuccess == 1 {
                        self.registerForAPNS()
                        // UserDefaults.standard.set("1", forKey: "isUserLoggedIN")
                        let downloadArray: Array<Any> = []
                        let uploadArray: Array<Any> = []
                        UserDefaults.standard.set(0, forKey: "isSocialLogin")
                        UserDefaults.standard.set(1, forKey: "isOperating")
                        UserDefaults.standard.set(uploadArray, forKey: "uploadSurveysArray")
                        UserDefaults.standard.set(downloadArray, forKey: "downloadSurveysArray")
                        UserDefaults.standard.set(self.txtUsername?.text, forKey: "Username")
                        UserDefaults.standard.set(self.txtPassword?.text, forKey: "Password")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "SurveyHome", sender: self)
                    }
                    else {
                        if authenticate.httpStatusCode.intValue == 406 {
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Invalid Credentials", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        }
                        else if authenticate.httpStatusCode.intValue == 401 {
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Unauthorised login", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        }
                        else if authenticate.httpStatusCode.intValue == 500 {
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Internal Server Error", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        }
                        else {
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        }
                    }
                }
            } catch let err as NSError {
                print("Error: \(err)")
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.setLoginControls(isInteractionEnabled: true)
                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                }
            }
        }
    }

    func registerForAPNS() {
        let sdk = OPGSDK()
        let deviceToken: String? = UserDefaults.standard.value(forKey: "DeviceTokenID") as? String
        if  deviceToken != nil {
            do {
                 try sdk.registerNotifications(deviceToken)
                print("APNs successfully registered")
            } catch let error as NSError {
                print("APNs registration failed due to \(error.localizedDescription)")
            }
        }
    }

    func authenticateWithFacebook(result: FBSDKLoginManagerLoginResult) {
        if result.token != nil {

            print("the token received is \(result.token.tokenString)")
            print("the user id is \(result.token.userID)")

            DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                do {
                    let tokenString: String = result.token.tokenString
                    let authObj = try sdk.authenticate(withFacebook: tokenString) as OPGAuthenticate
                    DispatchQueue.main.async {
                        if authObj.isSuccess == 1 {
                            let downloadArray: Array<Any> = []
                            let uploadArray: Array<Any> = []
                            self.registerForAPNS()
                            self.stopActivityIndicator()
                            UserDefaults.standard.set(1, forKey: "isOperating")
                            UserDefaults.standard.set(uploadArray, forKey: "uploadSurveysArray")
                            UserDefaults.standard.set(downloadArray, forKey: "downloadSurveysArray")
                            // UserDefaults.standard.set("1", forKey: "isUserLoggedIN")
                            UserDefaults.standard.set(1, forKey: "isSocialLogin")                  // set as 1 if loggedin thro' facebook
                            UserDefaults.standard.set(tokenString, forKey: "tokenString")
                            UserDefaults.standard.synchronize()
                            self.performSegue(withIdentifier: "SurveyHome", sender: self)           // Go to survey List screen on successful authentication
                        }
                        else {
                            self.stopActivityIndicator()
                            if authObj.httpStatusCode.intValue == 401 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Unauthorised login", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            // server always return http 500 for bad token and expired token
                            else if authObj.httpStatusCode.intValue == 500 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Internal Server Error", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                        }
                    }
                }
                catch let err as NSError
                {
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        print("Error: \(err)")
                    }
                }
            }
        }
    }

    func setLoginControls(isInteractionEnabled: Bool) {
        self.txtPassword?.isUserInteractionEnabled = isInteractionEnabled
        self.txtUsername?.isUserInteractionEnabled = isInteractionEnabled
        self.btnLogin?.isUserInteractionEnabled = isInteractionEnabled
        self.btnForgotPassword?.isUserInteractionEnabled = isInteractionEnabled
        self.btnFacebookLogin.isUserInteractionEnabled = isInteractionEnabled
        self.btnGooglePlusLogin.isUserInteractionEnabled = isInteractionEnabled
    }

    func startActivityIndicator() {
        self.activityIndicatorView?.isHidden = false
        self.activityIndicatorView?.startAnimating()
    }

    func stopActivityIndicator() {
        self.activityIndicatorView?.isHidden = true
        self.activityIndicatorView?.stopAnimating()
    }

    func setThemeElements() {
        let bgImagePath: String! = AppTheme.getLoginBGImagePath()
        if  bgImagePath.isEmpty {
            self.setBackgroundImageforView()                                // set default background
        }
        else {
            let fileExists = FileManager().fileExists(atPath: bgImagePath!)
            if fileExists {
                self.imgLoginBG?.image = UIImage(contentsOfFile: bgImagePath!)           // set theme BG image
            }
        }
        self.btnLogin?.setTitleColor(AppTheme.getLoginBtnTextColor(), for: .normal)       // set theme login btn color
        self.bgColor = AppTheme.getLoginBtnTextColor()
    }

    func checkForLogoImgAndText() {
        let headerLogoBGImagePath: String = AppTheme.getHeaderLogoImagePath()
        if (headerLogoBGImagePath.isEmpty) {
            let logoText: String = AppTheme.getLogoText()
            if logoText.isEmpty {
                // set default logo Image
                self.imgLogo?.contentMode = .scaleAspectFit
                if  UIDevice.current.userInterfaceIdiom == .phone {
                    let image = UIImage(named: "LoginPageLogo.png")
                    self.imgLogo?.image = image
                }
                else {
                    let image = UIImage(named: "LoginPageLogo_iPad.png")
                    self.imgLogo?.image = image
                }
                self.imgLogo?.isHidden = false
                self.lblLogoText?.isHidden = true
            }
            else {
                // set logo text
                self.lblLogoText?.adjustsFontSizeToFitWidth = true
                self.lblLogoText?.text = logoText
                self.imgLogo?.isHidden = true
                self.lblLogoText?.isHidden = false
            }
        }
        else {
            let fileExists = FileManager().fileExists(atPath: headerLogoBGImagePath)
            if fileExists {
                // set logo Image
                self.imgLogo?.contentMode = .scaleAspectFit
                self.imgLogo?.image = UIImage(contentsOfFile:headerLogoBGImagePath)           //set theme logo  image
                self.imgLogo?.backgroundColor = UIColor.clear
                self.imgLogo?.isHidden = false
                self.lblLogoText?.isHidden = true
            }
        }
    }

    func setBackgroundImageforView() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        if  UIDevice.current.userInterfaceIdiom == .phone {
            switch height {
            case OPGConstants.device.iPhone4Height:
                imgLoginBG?.image = UIImage(named: "LoginBg@2x.png")
                break
            case OPGConstants.device.iPhone5Height:
                print("iPhone 5")
                imgLoginBG?.image = UIImage(named: "LoginBg-568h@2x.png")
                break
            case OPGConstants.device.iPhone6And7Height:
                print("iPhone 6 or 7")
                imgLoginBG?.image = UIImage(named: "LoginBg-667h@2x.png")
                break
            case OPGConstants.device.iPhone6PlusAnd7PlusHeight:
                print("iPhone 6+ or 7+")
                imgLoginBG?.image = UIImage(named: "LoginBg-736@3x.png")
                break
            default:
                print("not an iPhone")
                imgLoginBG?.image = UIImage(named: "LoginBg.png")
                break
            }
        }
        else if UIDevice.current.userInterfaceIdiom == .pad {
            switch height {
            case OPGConstants.device.iPadPortraitHeight:
                print("iPad Portrait")
                imgLoginBG?.image = UIImage(named: "LoginBg_iPad_Portrait.png")
                break
            case OPGConstants.device.iPadLandscapeHeight:
                print("iPad Landscape")
                imgLoginBG?.image = UIImage(named: "LoginBg_iPad_Landscape.png")
                break
            default:
                print("not an iPad")
                imgLoginBG?.image = UIImage(named: "LoginBg-736@3x.png")
                break
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedForgot" {
            // Get common web view
            let viewController: ForgotPasswordViewController = segue.destination as! ForgotPasswordViewController
            viewController.bgColor=self.bgColor
        }
    }

    func hideKeyboard() -> UIToolbar {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(dismissKeyBoard))
        toolbarDone.items = [barBtnDone]
        return toolbarDone
    }

    func dismissKeyBoard() {
        self.txtUsername?.resignFirstResponder()
        self.txtPassword?.resignFirstResponder()
    }

    // MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!

        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        if textField.tag == 1 {
            if super.isOnline() {
                self.authenticate()
            }
            else {
                super.showNoInternetConnectionAlert()
            }
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        if textField.tag == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.constraintLoginViewCentre.constant = -50.0
                self.constraintImageViewTop.constant = -50.0
                self.constraintImageViewBottom.constant = 55.0
                if  UIDevice.current.userInterfaceIdiom == .pad {
                    self.constraintLogoText.constant = 90
                    self.constraintLogoImage.constant = 90
                }
                else {
                    self.constraintLogoText.constant = 40.0
                    self.constraintLogoImage.constant = 40.0
                }
                self.view.layoutIfNeeded()
            })
        }
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.constraintLoginViewCentre.constant = -60.0
                self.constraintImageViewTop.constant = -60.0
                self.constraintImageViewBottom.constant = 65.0
                if  UIDevice.current.userInterfaceIdiom == .pad {
                    self.constraintLogoText.constant = 80
                    self.constraintLogoImage.constant = 80
                }
                else {
                    self.constraintLogoText.constant = 30.0
                    self.constraintLogoImage.constant = 30.0
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.constraintLoginViewCentre.constant = 0
            self.constraintImageViewTop.constant = 0
            self.constraintImageViewBottom.constant = 0
            if  UIDevice.current.userInterfaceIdiom == .pad {
                self.constraintLogoText.constant = 140
                self.constraintLogoImage.constant = 140
            }
            else {
                self.constraintLogoText.constant = 70
                self.constraintLogoImage.constant = 70
            }

            self.view.layoutIfNeeded()
        })
    }

    // MARK: - GoogleSignin Delegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.startActivityIndicator()
        if error != nil {
            self.stopActivityIndicator()
            print(error)
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Can't sign in. Try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
            return
        }
        print("Email : " + user.profile.email + "\n")
        print(user.profile.imageURL(withDimension: 400))
        print("\n")
        print("ID Token : " + user.authentication.idToken + "\n")    // Safe to send to the server
        print("User ID : " + user.userID + "\n")                     // For client-side use only!
        print("Profile Name : " + user.profile.name + "\n")
        if user.authentication.idToken.isEmpty {
            self.stopActivityIndicator()
            if super.isOnline()==false {
                super.showNoInternetConnectionAlert()
            }
            else {
                // when token is nil even if the device is online
                // incorrect username and password is handled by Google on the webpage itself.
                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Can't sign in. Try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
            }
        }
        else {
            DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                do {
                    let tokenString: String = user.authentication.idToken
                    let authObj = try sdk.authenticate(withGoogle: tokenString) as OPGAuthenticate
                    DispatchQueue.main.async {
                            if authObj.isSuccess == 1 {
                                let downloadArray: Array<Any> = []
                                let uploadArray: Array<Any> = []
                                self.registerForAPNS()
                                self.stopActivityIndicator()
                                UserDefaults.standard.set(1, forKey: "isOperating")
                                UserDefaults.standard.set(uploadArray, forKey: "uploadSurveysArray")
                                UserDefaults.standard.set(downloadArray, forKey: "downloadSurveysArray")
                                // UserDefaults.standard.set("1", forKey: "isUserLoggedIN")
                                UserDefaults.standard.set(2, forKey: "isSocialLogin")                  // set as 2 if loggedin thro' Google
                                UserDefaults.standard.set(tokenString, forKey: "tokenString")
                                UserDefaults.standard.synchronize()
                                self.performSegue(withIdentifier: "SurveyHome", sender: self)           // Go to survey List screen on successful authentication
                            }
                            else {
                                self.stopActivityIndicator()
                                if authObj.httpStatusCode.intValue == 401 {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Unauthorised login", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                                }
                                    // server always return http 500 for bad token and expired token
                                else if authObj.httpStatusCode.intValue == 500 {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Internal Server Error", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                                }
                                else {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                                }
                                GIDSignIn.sharedInstance().signOut()                    // Sign Out when the authentication fails
                            }
                    }
                }
                catch let err as NSError {
                    DispatchQueue.main.async {
                            self.stopActivityIndicator()
                            print("Error: \(err)")
                    }
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Signin
    }

}
