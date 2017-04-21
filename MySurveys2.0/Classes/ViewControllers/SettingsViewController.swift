//
//  SettingsViewController.swift
//  MySurveys2.0
//
//  Created by ThamaraiD on 24/10/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import Foundation

let privacyUrl = "https://framework.onepointglobal.com/appwebsite/privacy?location=mobile&culture=en-US"
let tcUrl = "https://framework.onepointglobal.com/appwebsite/TermsOfUse?location=mobile&culture=en-US"
let aboutUsUrl = "https://framework.onepointglobal.com/appwebsite/about?location=mobile&culture=en-US"

let geoFence = OPGMSGeoFencing.sharedInstance()

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - IBOutlets for View
    @IBOutlet weak var tableView : UITableView!

    
    // MARK: - Properties for viewcontroller
    var settingItems : [String] = []
    var urlString : String?
    var pageTitle : String?
    
    
    // MARK: - View Delegate Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        settingItems += [NSLocalizedString("Change Panel", comment: ""), NSLocalizedString("Geo location", comment: ""), NSLocalizedString("Change Password", comment: ""), NSLocalizedString("Privacy", comment: ""), NSLocalizedString("Terms & Conditions", comment: ""), NSLocalizedString("AboutUs", comment: "")]
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false

        //set theme color for the switch ON tint color
        let indexPath = IndexPath(item: 1, section: 0)
        let tableViewCell : SettingsTableViewCell? = self.tableView?.cellForRow(at: indexPath) as? SettingsTableViewCell
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
        let tableViewCell : SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsTableViewCell

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
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "changePanel", sender: self)
            
        case 2:
            self.performSegue(withIdentifier: "changePassword", sender: self)

        case 3:
            self.urlString = privacyUrl                                            //set url to load in the next screen
            self.pageTitle = NSLocalizedString("Privacy", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        case 4:
            self.urlString = tcUrl
            self.pageTitle = NSLocalizedString("T&C", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        case 5:
            self.urlString = aboutUsUrl
            self.pageTitle = NSLocalizedString("AboutUs", comment: "")
            self.performSegue(withIdentifier: "commonWebView", sender: self)

        default:
            break
        }
    }
    
    // MARK: - Segue Operations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "commonWebView")
        {
            // Get common web view
            let viewController : AboutUsViewController = segue.destination as! AboutUsViewController
            viewController.urlString=self.urlString
            viewController.pageTitle = self.pageTitle
        }
    }
    
    func switchEvents(sender : AnyObject) {
        let switchControl = sender as! UISwitch
        if switchControl.isOn {
            print("GeoFencing started")
            UserDefaults.standard.set("1", forKey: "isGeoFenced")
            geoFence?.start()
        } else {
            let array = CollabrateDB.sharedInstance().getAllGeoFenceSurveys() as! Array<OPGMSGeoFencingModel>
            DispatchQueue.global(qos: .default).sync {
                for element in array {
                    CollabrateDB.sharedInstance().deleteGeoFenceSurvey(element.surveyID)
                }
            }
            UserDefaults.standard.set("0", forKey: "isGeoFenced")
            geoFence?.stop()
            print("GeoFencing stopped")
        }
    }
}
