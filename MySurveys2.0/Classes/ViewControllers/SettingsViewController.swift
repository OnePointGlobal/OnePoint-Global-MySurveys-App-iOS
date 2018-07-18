//
//  SettingsViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 24/10/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation
import CoreLocation



class SettingsViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    // MARK: - IBOutlets for View
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var lblVersion: UILabel!

    // MARK: - Properties for viewcontroller
    var settingItems: [String] = []
    var urlString: String?
    var pageTitle: String?
    var geofencedArrays: Array<Any> = []
    var myLocation: CLLocationCoordinate2D?

    // Append locale based on language selected.
    var privacyUrl = "https://framework.onepointglobal.com/appwebsite/privacy?location=mobile&culture="
    var tcUrl = "https://framework.onepointglobal.com/appwebsite/TermsOfUse?location=mobile&culture="
    var aboutUsUrl = "https://framework.onepointglobal.com/appwebsite/about?location=mobile&culture="

    // MARK: - View Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        settingItems += [NSLocalizedString("Change Panel", comment: ""), NSLocalizedString("Geo location", comment: ""), NSLocalizedString("Change Password", comment: ""), NSLocalizedString("Privacy", comment: ""), NSLocalizedString("Terms & Conditions", comment: ""), NSLocalizedString("AboutUs", comment: "")]

        self.settingsTableView.tableFooterView = UIView()
        self.lblVersion.text = NSLocalizedString("Version", comment: "") + " 2.0.9 "
        geoFence?.initialiseGeofencing()            // Ask for location permission
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false

        // set theme color for the switch ON tint color
        let indexPath = IndexPath(item: 1, section: 0)
        let tableViewCell: SettingsTableViewCell? = self.settingsTableView?.cellForRow(at: indexPath) as? SettingsTableViewCell
        tableViewCell?.switchControl.onTintColor = AppTheme.appBackgroundColor()

    }

    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80.0
        } else {
            return 60.0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsTableViewCell

        if indexPath.row == 1 {
            tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
            tableViewCell.layoutMargins = UIEdgeInsets.zero
            tableViewCell.fillCell(items: settingItems[indexPath.row], isGeoFencing: true)
            tableViewCell.switchControl.addTarget(self, action: #selector(switchEvents), for: UIControlEvents.valueChanged)
            tableViewCell.accessoryType = .none

        } else {
            tableViewCell.accessoryType = .disclosureIndicator
            tableViewCell.layoutMargins = UIEdgeInsets.zero
            tableViewCell.fillCell(items: settingItems[indexPath.row], isGeoFencing: false)
        }
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "changePanel", sender: self)
        case 2:
            self.performSegue(withIdentifier: "changePassword", sender: self)

        case 3:
            let langStr = Locale.current.languageCode
            self.urlString = self.privacyUrl.appending(langStr!)                                           // set url to load in the next screen
            self.pageTitle = NSLocalizedString("Privacy", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        case 4:
            let langStr = Locale.current.languageCode
            self.urlString = self.tcUrl.appending(langStr!)
            self.pageTitle = NSLocalizedString("T&C", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        case 5:
            let langStr = Locale.current.languageCode
            self.urlString = self.aboutUsUrl.appending(langStr!)
            self.pageTitle = NSLocalizedString("AboutUs", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        default:
            break
        }
    }

    // MARK: - Segue Operations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commonWebView" {
            // Get common web view
            let viewController: AboutUsViewController = segue.destination as! AboutUsViewController
            viewController.urlString=self.urlString
            viewController.pageTitle = self.pageTitle
        }
    }

     // MARK: - Geofencing Operations
    @objc func switchEvents(sender: AnyObject) {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        let switchControl = sender as! UISwitch
        if switchControl.isOn {
            print("GeoFencing started")
            if super.isOnline() {
                if (geoFence?.isMonitoringAllowed())! {
                    UserDefaults.standard.set("1", forKey: "isGeoFenced")
                    self.getGeofencedSurveys()
                }
                else {
                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enable location services from device Settings to take the survey.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
                    switchControl.setOn(false, animated: true)
                }
            }
            else {
                super.showNoInternetConnectionAlert()
                switchControl.setOn(false, animated: true)
            }
        }
        else {
            dispatchQueue.async(flags: .barrier) {
                CollabrateDB.sharedInstance().deleteGeoFenceTable()
            }
            UserDefaults.standard.set("0", forKey: "isGeoFenced")
            geoFence?.stopMonitorForGeoFencing()
            print("GeoFencing stopped")
        }
    }

    func getGeofencedSurveys() {
        let locationManager = CLLocationManager()
        self.myLocation = locationManager.location?.coordinate
        if self.myLocation != nil {
            var arrayLocations : NSArray = []
            dispatchQueue.async(flags: .barrier) {
                let sdk = OPGSDK()
                do {
                    arrayLocations = try sdk.getGeofenceSurveys(Float((self.myLocation?.latitude)!), longitude: Float((self.myLocation?.longitude)!)) as NSArray
                    DispatchQueue.main.async {
                        if arrayLocations.count > 0 {
                            self.saveGeofenceSurveysToDB(arrayLocations as! [OPGGeofenceSurvey])
                        }
                        else {
                            //Do nothing if there are no geo surveys for this panellist
                            print("No geofenced survey locations to monitor")
                        }
                    }
                }
                catch let err as NSError {
                    DispatchQueue.main.async {
                        print("Error: \(err)")
                        super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        self.resetUISwitch(toStatus: false)
                    }
                }
            }
        }
        
    }

    func saveGeofenceSurveysToDB(_ locations: [OPGGeofenceSurvey]!) {
        let array : Array<OPGGeofenceSurvey> = (locations)!
        if (array.count) > 0 {
            dispatchQueue.async(flags: .barrier) {
                let concurrentQueue = DispatchQueue(label: "saveGeoFenceSurveys")
                for survey in array {
                    concurrentQueue.sync() {
                        CollabrateDB.sharedInstance().saveGeoFenceSurveys(survey)
                    }
                }
                concurrentQueue.sync() {
                    self.geofencedArrays = CollabrateDB.sharedInstance().getAllGeoFenceSurveys()
                }
                DispatchQueue.main.async {
                    var error: NSError?
                    if self.geofencedArrays.count > 0 {
                        let dictionary = ["geoArray" : self.geofencedArrays]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OPGGeofencedArraysObtained"), object: nil, userInfo: dictionary)
                        geoFence?.startMonitor(forGeoFencing: self.geofencedArrays as! [OPGGeofenceSurvey], error: &error)
                        if error != nil {
                            print(error.debugDescription)
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            self.resetUISwitch(toStatus: false)
                        }
                    }
                }
            }
        }
    }

    func resetUISwitch(toStatus: Bool) {
        let indexPath = IndexPath(item: 1, section: 0)
        let tableViewCell: SettingsTableViewCell? = self.settingsTableView?.cellForRow(at: indexPath) as? SettingsTableViewCell
        tableViewCell?.switchControl.setOn(toStatus, animated: true)
    }

    
}
