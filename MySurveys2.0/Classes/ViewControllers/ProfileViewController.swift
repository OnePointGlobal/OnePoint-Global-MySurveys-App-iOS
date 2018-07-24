//
//  ProfileViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 20/06/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit
import RNCryptor


class ProfileViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CountryChangedDelegate {
   // MARK: - IBOutlets for view
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var lblCountry: UILabel?
    @IBOutlet weak var lblEmail: UILabel?
    @IBOutlet weak var tableview: UITableView?
    @IBOutlet weak var btnEdit: UIBarButtonItem?
    @IBOutlet weak var bgImage: UIImageView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var viewHeight: NSLayoutConstraint?
    @IBOutlet weak var btnCameraIcon: UIButton?

    // MARK: - Properties for viewcontroller
    var titleArray: [String] = []
    var panelist: OPGPanellistProfile?
    var profileImgMediaID: String?
    var isEditable: Bool?
    var profileImgPath: String?
    let aes_key = ""

    // MARK: - Getter Setter Methods
    func setProfileImagePath(path: String) {
        let url = NSURL(string: path)
        let filename: String = url!.lastPathComponent!                                                 // set only imageName to defaults to fetch path when needed from tmp folder
        let defaults = UserDefaults.standard
        defaults.set(filename, forKey: "profileImagePath")
        defaults.synchronize()
    }

    func getProfileImagePath() -> String {
        let filename = UserDefaults.standard.object(forKey: "profileImagePath") as? String
        if filename != nil {
            let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename!)        // get image name, construct path and return
            return (tempDirURL?.path)!
        }
        return EMPTY_STRING
    }

    func getDateString() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        let utcTimeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = utcTimeZone! as TimeZone
        dateFormatter.dateFormat = "HH_mm_ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
        return dateFormatter.string(from: date as Date)
    }

     // MARK: - View delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleArray += [NSLocalizedString("Name", comment: ""), NSLocalizedString("Country", comment: ""), NSLocalizedString("E-mail Id", comment: "")]
        self.tableview?.delegate=self
        self.tableview?.dataSource=self
        self.tableview?.allowsSelection = false                  // Disable table view selection
        self.tableview?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableview?.isScrollEnabled=false
        self.activityIndicator?.color = AppTheme.appBackgroundColor()
        self.configureUI()
        self.getPanellistProfileFromDB()
        if self.panelist != nil {
            print(self.panelist as Any)
        }
        self.isEditable=false
        self.view.layoutIfNeeded()
        circularImage(imageView)
        let cameraIconWidth =  btnCameraIcon?.bounds.size.width
        btnCameraIcon?.layer.cornerRadius = 0.5 * cameraIconWidth!
        if UIDevice.current.userInterfaceIdiom == .pad {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isOperating: Int? = UserDefaults.standard.value(forKey: "isOperating") as? Int
        let array: Array<Any>? = UserDefaults.standard.value(forKey: "downloadSurveysArray") as? Array<Any>
        if isOperating == 2 && array?.count == 0 {
            if self.panelist?.firstName == nil || self.panelist?.countryName == nil {
                self.getPanellistProfileFromDB()                        // get from DB again if profile was not loaded due to internet disconnetivity.
            }
        }  // thamarai changes
        if isEditable! {
            let btnEdit =  UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(editProfile))
            self.tabBarController?.navigationItem.rightBarButtonItem = btnEdit
        }
        else {
            let btnEdit =  UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(editProfile))
            self.tabBarController?.navigationItem.rightBarButtonItem = btnEdit
            self.tableview?.separatorStyle = UITableViewCellSeparatorStyle.none
            self.tableview?.allowsSelection = false
            self.tableview?.reloadData()                 // to disable editing after coming back to profile screen which was left in edit mode
        }
        let path: String? = UserDefaults.standard.object(forKey: "profileImagePath") as? String
        if path==nil || (path?.isEmpty)! {
            // Set default image
            self.imageView?.image = UIImage(named: "profile_default.png")
            // download again if profile pic was not loaded due to internet disconnetivity.
            if  self.panelist?.mediaID != nil && self.panelist?.mediaID != "0" && self.panelist?.mediaID != "" {
                self.activityIndicator?.startAnimating()
                self.downloadProfileImage(mediaId: self.panelist!.mediaID.description, didChangeProfilePic: false)              // media ID coming from DB is Int so need explicit cast(description).
            }
        }
        else {
            let imgPath = self.getProfileImagePath()
            let fileExists = FileManager().fileExists(atPath: (imgPath))
            if fileExists {
                let imageToDisplay = self.decryptProfileImg(imgPath: imgPath)
                self.imageView?.image = imageToDisplay.fixOrientation()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        // self.isEditable = false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            let bounds = UIScreen.main.bounds
            let height = bounds.size.height
            if self.tableview != nil {
                if height==OPGConstants.device.iPadLandscapeHeight || height==OPGConstants.device.iPadRetinaLandscapeHeight {
                    // enable scroll for iPad landscape
                    self.tableview?.isScrollEnabled=true
                }
                else {
                    self.tableview?.isScrollEnabled=false
                }
            }
        })
    }

    // MARK: - DB methods
    func getPanellistProfileFromDB() {
        dispatchQueue.async(flags: .barrier) {
            self.panelist = CollabrateDB.sharedInstance().getPanellistProfile()
            let country: OPGCountry = CollabrateDB.sharedInstance().getCountry()                // country details stored in Country table, not in Panellist Profile table.
            self.panelist?.std = country.std
            self.panelist?.countryName = country.name
        }
    }

    // MARK: - Keyboard Notification selector methods
    @objc func keyboardWillShow(notification: NSNotification) {
        // only for iPad
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        if width==OPGConstants.device.iPadLandscapeWidth || width==OPGConstants.device.iPadRetinaLandscapeWidth {
            // only for iPad landscape
            let indexPath = IndexPath(item: 0, section: 0)
            let tableViewCell: ProfileTableViewCell? = self.tableview?.cellForRow(at: indexPath) as? ProfileTableViewCell
            if tableViewCell != nil {
                tableViewCell?.constarintNameTopSpace.constant = -35
            }
            self.view.updateConstraints()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        // only for iPad
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        if width==OPGConstants.device.iPadLandscapeWidth || width==OPGConstants.device.iPadRetinaLandscapeWidth {
            // only for iPad landscape
            let indexPath = IndexPath(item: 0, section: 0)
            let tableViewCell: ProfileTableViewCell? = self.tableview?.cellForRow(at: indexPath) as? ProfileTableViewCell
            if tableViewCell != nil {
                tableViewCell?.constarintNameTopSpace.constant = 40
            }
            self.view.updateConstraints()
        }
    }


    // MARK: - Generic Private methods
    func configureUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width

        if UIDevice.current.userInterfaceIdiom == .pad {
            if width==OPGConstants.device.iPadLandscapeWidth || width==OPGConstants.device.iPadRetinaLandscapeWidth {
                // enable scroll if iPad landscape is loaded first time
                self.tableview?.isScrollEnabled=true
            }
        }
        else {
            if height == OPGConstants.device.iPhone4Height {
                // Enable scroll only for 4S
                self.tableview?.isScrollEnabled=true
            }
        }
    }

    func hideKeyboard() {
        let indexPath = IndexPath(item: 0, section: 0)
            let tableViewCell: ProfileTableViewCell? = self.tableview?.cellForRow(at: indexPath) as? ProfileTableViewCell
            if tableViewCell != nil {
                tableViewCell?.txtValue.resignFirstResponder()
            }
    }


    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate=self
        imagePicker.sourceType =  .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate=self
        imagePicker.sourceType =  .camera
        present(imagePicker, animated: true, completion: nil)
    }

    func circularImage(_ photoImageView: UIImageView?) {
        // photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
        photoImageView!.layer.borderColor = UIColor.gray.cgColor
        photoImageView!.layer.cornerRadius = photoImageView!.frame.width/2
        photoImageView!.layer.masksToBounds = false
        photoImageView!.clipsToBounds = true
        photoImageView!.layer.borderWidth = 0.5
        photoImageView!.contentMode = UIViewContentMode.scaleAspectFill
    }

    // This method updates the panellist profile after editing
    func updateProfile() {
        if super.isOnline() == false {
            super.showNoInternetConnectionAlert()
            self.tableview?.reloadData()
            return
        }
        let nameCell = self.tableview?.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        if nameCell.txtValue.text!.isEmpty {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Name is empty", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
            // If name is edited to an empty string, don't update profile
            self.tableview?.reloadData()
        }
        else {
            self.panelist?.firstName = nameCell.txtValue.text!
            DispatchQueue.global(qos: .default).async {
                    let sdk = OPGSDK()
                    do {
                        try sdk.update(self.panelist)                               // update profile to server
                        DispatchQueue.main.async {
                                self.getPanellistProfileFromServer()                // get profile from server and update DB
                                self.tableview?.reloadData()
                        }
                    }
                    catch let err as NSError
                    {
                        print("Error: \(err)")
                    }
            }
        }
    }

    // This method gets the panellist profile information from the server.
    func getPanellistProfileFromServer() {
        DispatchQueue.global(qos: .default).async {
            let sdk = OPGSDK()
            do {
                self.panelist = try sdk.getPanellistProfile() as OPGPanellistProfile
                DispatchQueue.main.async {
                    if self.panelist != nil {
                         dispatchQueue.async(flags: .barrier) {
                            CollabrateDB.sharedInstance().update(self.panelist!)                     // Update DB only after successfully updating the server.
                            DispatchQueue.main.async {
                                dispatchQueue.async(flags: .barrier) {
                                    CollabrateDB.sharedInstance().updateCountry(self.panelist?.countryName, withStd: self.panelist?.std)
                                }
                            }

                        }
                    }
                }
            }
            catch let err as NSError {
                print("Error: \(err)")
            }
        }
    }

    // Logout method clears User Defaults, unregisters for App Notifications, stops geofencing, deletes temp folder contents.
    // You will no longer be able to access any of the api via SDK after you logout.
    func logout() {
        let isiPhoneXAdjusted: String? = UserDefaults.standard.value(forKey: "iPhoneXAdjusted") as? String
        let isSocialLogin = UserDefaults.standard.value(forKey: "isSocialLogin") as? Int
        let deviceToken: String? = UserDefaults.standard.value(forKey: "DeviceTokenID") as? String
        let panelID: String? = UserDefaults.standard.value(forKey: selectedPanelID) as? String              //fetch the updated panelID again
        let panelName: String? = UserDefaults.standard.value(forKey: selectedPanelName) as? String
        let bgImagePath: String? = AppTheme.getLoginBGImagePath()
        let logoImgPath: String? = AppTheme.getHeaderLogoImagePath()
        let appBGColor: UIColor = AppTheme.appBackgroundColor()
        let logoText: String? = AppTheme.getLogoText()
        self.unRegisterForAPNS(deviceToken)
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        if geoFence?.fencingDelegate != nil {
            geoFence?.stopMonitorForGeoFencing()
        }
        self.deleteTempDBFolders()
        if isSocialLogin == 1 {
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()                                           // Facebook logout
        }
        else if isSocialLogin == 2 {
            GIDSignIn.sharedInstance().signOut()                    // Sign Out of Google
        }
        else {
            OPGSDK.logout()
        }
        if panelName != nil {
            UserDefaults.standard.set(panelName, forKey: selectedPanelName)
        }
        if panelID != nil {
            UserDefaults.standard.set(panelID, forKey: selectedPanelID)
        }
        if isiPhoneXAdjusted != nil {
            UserDefaults.standard.set(isiPhoneXAdjusted, forKey: "iPhoneXAdjusted")
        }
        UserDefaults.standard.set("0", forKey: "isUserLoggedIN")                    // 0 indicates not logged in or logout
        UserDefaults.standard.set(deviceToken, forKey: "DeviceTokenID")             // Before Logout, Re-assign DeviceTokenID as we get that only for one time
        AppTheme.setLoginBGImagePath(path: bgImagePath!)                            // Before Logout, Re-assign login BG image path as it is to be shown after logout
        AppTheme.setLoginBtnTextColor(color: AppTheme.appBackgroundColor())
        AppTheme.setHeaderLogoImagePath(path: logoImgPath!)
        AppTheme.setLogoText(text: logoText!)
        AppTheme.setAppBackgroundColor(color: appBGColor)               // reset appBG color after cleaning defaults
        UserDefaults.standard.synchronize()
        _ = self.navigationController?.popViewController(animated: true)
    }

    func unRegisterForAPNS(_ deviceToken: String?) {
        let sdk = OPGSDK()
        if  deviceToken != nil {
            do {
                try sdk.unregisterNotifications(deviceToken)
                print("APNs successfully unregistered")
            } catch let error as NSError {
                print("APNs unregistration failed due to \(error.localizedDescription)")
            }
        }
    }

    func deleteTempDBFolders() {
        let filemanager = FileManager.default
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let panelImagePath = documentsPath.appending("/PanelImages")
        if filemanager.fileExists(atPath: panelImagePath) {
            do {
                try filemanager.removeItem(atPath: panelImagePath)
            } catch let err as NSError {
                print("Error occured while copying and the error is \(err.description)")
            }
        }
        OPGDB.deleteOldDatabase()
        OPGDB.initialize(withDBVersion: OPGConstants.sdk.DatabaseVersion)
        OPGSDK.setAppVersion(OPGConstants.sdk.AppVersion)
        OPGSDK.initialize(withUserName: OPGConstants.sdk.Username, withSDKKey: OPGConstants.sdk.SharedKey)
    }

    func deletePreviousProfileImg(path: String?) {
        if path != nil {
            let filemanager = FileManager.default
            if filemanager.fileExists(atPath: path!) {
                do {
                    try filemanager.removeItem(atPath: path!)
                    print("Deleted the old profile image from temp folder")
                }
                catch let err as NSError {
                    print("Error occured while deleting profile pic and the error is \(err.description)")
                }
            }
        }
    }

    // This method updates the panellist profile object with the new media ID after the user changes the profile picture.
    func updatePanellistProfileWithMedia(mediaID: String) {
        if super.isOnline() == false {
            self.activityIndicator?.stopAnimating()
            super.showNoInternetConnectionAlert()
            return
        }
        self.panelist?.mediaID = mediaID

        DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                do {
                    try sdk.update(self.panelist)                             // Updating the profile with new media ID
                    DispatchQueue.main.async {
                        self.getPanellistProfileFromServer()                  // After server update is done, update DB
                    }
                }
                catch let err as NSError {
                    print("Error: \(err)")
                    DispatchQueue.main.async {
                        self.activityIndicator?.stopAnimating()
                        super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                    }
                }
        }
    }

    func encryptProfileImg(imgPath: String) {
        // Gets the profile image downloaded by SDK, converts to Data, deletes it and encryptes the Data and write to a file
        let image = UIImage(contentsOfFile: imgPath)
        let data:Data = UIImagePNGRepresentation(image!)!
        self.deleteImgFromPath(path: imgPath)
        let encryptedData: Data = RNCryptor.encrypt(data: data, withPassword: "ABCD")
         do {
            try encryptedData.write(to: URL(fileURLWithPath: imgPath), options: Data.WritingOptions.atomic)
        }
        catch {
                // Catch exception here and act accordingly
                print("Writing Encrypted Profile Image Data Failed")
        }
    }

    func decryptProfileImg(imgPath: String) -> UIImage {
        //Gets the encrypted image Data, decrypts it and returns a UIImage out of it.
        let imgData  = NSData(contentsOfFile: imgPath)
        var decryptedData:Data?
        do {
            decryptedData = try RNCryptor.decrypt(data: imgData! as Data, withPassword: "ABCD")
        }
        catch {
                // Catch exception here and act accordingly
                print("Decrypting Profile Image Data Failed")
        }
        //let cryptor: RNCryptor
        return UIImage(data: decryptedData!)!
    }

    // This method downloads the profile picture of the panellist
    func downloadProfileImage(mediaId: String, didChangeProfilePic: Bool) {
        var previousProfileImgPath: String?
        if super.isOnline() == false {
            self.activityIndicator?.stopAnimating()
            super.showNoInternetConnectionAlert()
            return
        }
        if didChangeProfilePic {
            previousProfileImgPath = self.getProfileImagePath()
        }

        DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                var mediaObj: OPGDownloadMedia?
                do {
                    mediaObj = try sdk.downloadMediaFile(mediaId, mediaType: "jpg", fileName: "ProfileImg"+self.getDateString())
                   // mediaObj  = try sdk.downloadMediaFile(mediaId, mediaType: "jpg") as OPGDownloadMedia
                    DispatchQueue.main.async {
                            if super.isOnline()==false {
                                self.activityIndicator?.stopAnimating()
                                super.showNoInternetConnectionAlert()
                                return
                            }
                            if mediaObj?.isSuccess == 1 {
                                self.activityIndicator?.stopAnimating()
                                self.profileImgPath = mediaObj!.mediaFilePath
                                self.encryptProfileImg(imgPath: self.profileImgPath!)
                                if mediaObj!.mediaFilePath != nil {
                                    self.setProfileImagePath(path: mediaObj!.mediaFilePath)
                                }

                                //decrypt the profile image
                               let imageToDisplay = self.decryptProfileImg(imgPath: self.profileImgPath!)
                                self.imageView?.image = imageToDisplay.fixOrientation()

                                if didChangeProfilePic {
                                    let fileExists = FileManager().fileExists(atPath: previousProfileImgPath!)
                                    if fileExists {
                                        self.deletePreviousProfileImg(path: previousProfileImgPath)                     // delete old profile pic once new one is updated
                                    }
                                    self.updatePanellistProfileWithMedia(mediaID: mediaId)                          // Update Panellist Profile with new media id using sdk api
                                }
                            }
                            else {
                                self.activityIndicator?.stopAnimating()
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                    }
                }
                catch let err as NSError {
                    print("Error: \(err)")
                    DispatchQueue.main.async {
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            self.activityIndicator?.stopAnimating()
                    }
                }
        }
    }

    // This method uploads the profile picture of the panellist
    func uploadProfileImage(path: String) {
        if super.isOnline() == false {
            super.showNoInternetConnectionAlert()
            return
        }
        DispatchQueue.global(qos: .default).async {
            let sdk = OPGSDK()
            do {
                self.profileImgMediaID = try sdk.uploadMediaFile(path) as String?                // Upload the new profile pic
                DispatchQueue.main.async {
                    if self.profileImgMediaID != nil {
                        self.deleteImgFromDocsDirectory()                   // delete image after upload which was written into documents directory from albums
                        print(self.profileImgMediaID!)
                        self.downloadProfileImage(mediaId: self.profileImgMediaID!, didChangeProfilePic: true)
                    }
                    else {
                        self.activityIndicator?.stopAnimating()
                        super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                    }
                }
            }
            catch let err as NSError {
                DispatchQueue.main.async {
                    print("Error: \(err)")
                    self.activityIndicator?.stopAnimating()
                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                }
            }

        }
    }

    func deleteImgFromDocsDirectory() {
        let fileManager = FileManager.default
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filepath = documentsPath.appending("/profileimage.jpg")
        if fileManager.fileExists(atPath: filepath) {
            do {
                try fileManager.removeItem(atPath: filepath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong in deleting Image from Documents directory: \(error)")
            }
        }
    }

    func deleteImgFromPath(path:String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong in deleting Image from path specified: \(error)")
            }
        }
    }

    // MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        _ = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent("profileimage.jpg")
        let data              = UIImageJPEGRepresentation(image,1.0)
        let img              = UIImage(data: data!)

        if let compressedData: Data = img?.compressTo(1) {
            do {
                try compressedData.write(to: localPath!, options: Data.WritingOptions.atomic)
            }
            catch {
                // Catch exception here and act accordingly
            }
            if !((localPath?.absoluteString.isEmpty)!) {
                self.activityIndicator?.startAnimating()
                self.uploadProfileImage(path: (localPath?.absoluteString)!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - IBOutlet Action methods
    @IBAction func cameraAction(_ sender: UIButton) {
        if super.isOnline() {
            let alert = UIAlertController(title: NSLocalizedString("MySurveys", comment: "App Name"), message: NSLocalizedString("Profile image", comment: "Profile image"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: UIAlertActionStyle.default, handler: {
                action in self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: "gallery"), style: UIAlertActionStyle.default, handler: {
                action in self.openGallery()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            super.showNoInternetConnectionAlert()
        }
    }

    // This method checks if there is any offline survey results not uploaded yet.
    // It is called during the logout operation
    func allowLogout() -> Bool {
        var contents: Array<Any>?
        let panellistID: String = UserDefaults.standard.value(forKey: "PanelListID") as! String
        let filemanager = FileManager.default
        let documentsPath: String? = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        var offlineResultsPath = documentsPath?.appending("/Caches/OPG_SurveyCache_Completed/")
        offlineResultsPath?.append(panellistID)
        if filemanager.fileExists(atPath: offlineResultsPath!) {
            do {
            contents = try filemanager.contentsOfDirectory(atPath: offlineResultsPath!)
            }
            catch let error as NSError {
                // Directory not exist, no permission, etc.
                print(error.localizedDescription)
                return false
            }
        }
        if (contents?.count)! > 0 {
            // Don't allow logout when offline result files still exist
            return false
        }
        return true
    }

    @objc func showAlert(sender: UIButton!) {
        if !self.allowLogout() {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: "App Name"), alertMessage: NSLocalizedString("Please upload offline survey results before logout.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
        }
        else {
            if super.isOnline() {
                let alert = UIAlertController(title: NSLocalizedString("MySurveys", comment: "App Name"), message: NSLocalizedString("Are you sure you want to logout?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.default, handler: {
                    action in self.logout()
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                super.showNoInternetConnectionAlert()
            }
        }
    }
    
    @objc func editProfile() {
        if super.isOnline() {
            if self.isEditable! {
                self.isEditable = false
                self.tabBarController?.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Edit", comment: "")
                self.tableview?.allowsSelection = false
                self.tableview?.separatorStyle = UITableViewCellSeparatorStyle.none
                self.hideKeyboard()                 // dismiss keyboard first and then update profile
                self.updateProfile()
            }
            else {
                self.isEditable = true
                self.tabBarController?.navigationItem.rightBarButtonItem?.title=NSLocalizedString("Save", comment: "")
                self.tableview?.allowsSelection = true
                self.tableview?.isScrollEnabled=true
                self.tableview?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableview?.reloadData()                 // to enable country btn and name txtfld after hitting edit
            }
        }
        else {
            if self.isEditable! {                            // calls when internet turned off during saving
                self.isEditable = false
                self.tabBarController?.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Edit", comment: "")
                self.tableview?.allowsSelection = false
                self.tableview?.separatorStyle = UITableViewCellSeparatorStyle.none
                self.getPanellistProfileFromDB()                    // get from DB again because profile object is edited locally in the class
                self.tableview?.reloadData()
            }
            super.showNoInternetConnectionAlert()
        }
    }

    // MARK: - Custom Delegate Method
    func userDidChangeCountry(newCountry: OPGCountry) {
         if newCountry.name.count > 0 {
            self.panelist?.countryName = newCountry.name
            self.panelist?.std = newCountry.std
            let nameCell = self.tableview?.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
            self.panelist?.firstName = nameCell.txtValue.text!
            self.tableview?.reloadData()
        }
    }

    func restoreEditMode() {
        self.isEditable = true
        self.tableview?.reloadData()
    }


    // MARK: - Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 110.0
        } else {
            return (self.tableview?.rowHeight)!
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Profile") as! ProfileTableViewCell
            if self.panelist?.firstName == nil {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: "", tagIdentifier: 1)
            }
            else {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: (panelist?.firstName)!, tagIdentifier: 1)
            }
            if isEditable! {
                tableViewCell.txtValue.isEnabled=true
                // tableViewCell.txtValue.perform(#selector(becomeFirstResponder), with: nil , afterDelay: 0)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // 15 is for iPhone
                    tableViewCell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
                }
            }
            else {
                tableViewCell.txtValue.isEnabled=false
                // tableViewCell.txtValue.resignFirstResponder()
                // self.view.endEditing(true)
            }
            tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
            return tableViewCell

        case 1:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Country") as! ProfileTableViewCountryCell
            if self.panelist?.countryName == nil {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: "")
            }
            else {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: (self.panelist?.countryName)!)
            }
            if isEditable! && UIDevice.current.userInterfaceIdiom == .pad {
                // 15 is for iPhone
                tableViewCell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
            tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
            return tableViewCell

        case 2:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Profile") as! ProfileTableViewCell
            tableViewCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 1000)
            if self.panelist?.email == nil {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: "", tagIdentifier: 1)
            }
            else {
                tableViewCell.fillCell(title: titleArray[indexPath.row], value: (panelist?.email)!, tagIdentifier: 1)
            }
            tableViewCell.txtValue.isEnabled = false
            tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
            return tableViewCell

        case 3:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Logout") as! ProfileLogoutTableViewCell
            tableViewCell.btnLogout.addTarget(self, action: #selector(showAlert(sender:)), for: UIControlEvents.touchUpInside)
            tableViewCell.btnLogout.setTitle(NSLocalizedString("Log out", comment: ""), for: .normal)
            tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
            return tableViewCell
        default:
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Profile") as! ProfileTableViewCell
            return tableViewCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "ShowCountries", sender: nil)
        }
    }

    // MARK: - Segue Operations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCountries" {
            let viewController: CountriesListViewController = segue.destination as! CountriesListViewController
            viewController.delegate=self
        }
    }
    
}
