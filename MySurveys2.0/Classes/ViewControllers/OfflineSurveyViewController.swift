//
//  OfflineSurveyViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 07/11/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation

class OfflineSurveyViewController: RootViewController {

    @IBOutlet weak var lblSurveyName: UILabel?
    @IBOutlet weak var lblSurveyStatus: UILabel?
    @IBOutlet weak var lblSurveyDate: UILabel?
    @IBOutlet weak var lblSurveyETA: UILabel?
    @IBOutlet weak var lblNumberOfTimes: UILabel!
    @IBOutlet weak var btnTakeSurvey: UIButton!
    @IBOutlet weak var btnTakeTrail: UIButton!
    @IBOutlet weak var btnUploadResults: UIButton!
    @IBOutlet weak var lblCounter: UILabel?
    @IBOutlet weak var dateView: UIView?
    @IBOutlet weak var approxTimeView: UIView?
    @IBOutlet weak var numberOfTimesView: UIView?
    @IBOutlet weak var progressView: UIProgressView!
    var surveyID: NSNumber?
    var surveySelected: OPGSurvey?
    var selectedSurveyIndex: IndexPath?
    var surveyCounter: NSNumber?
    var totalNumberOfFiles = 0
    var numberOfFilesPending  = 0
    var numberOfFilesUploaded = 0

    // MARK: - View Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.hidesBarsOnSwipe = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProgressBar(_:)), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        self.btnUploadResults.setTitle(NSLocalizedString("Upload Results", comment: ""), for: .normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.btnTakeSurvey.setImage(UIImage(named: "surveydetail_nav_iPad.png"), for: .normal)
        }
        else {
            self.btnTakeSurvey.setImage(UIImage(named: "surveydetail_nav.png"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Back", comment: "Back")
        self.navigationItem.title = NSLocalizedString("Survey", comment: "Survey")
        self.progressView.progressTintColor = AppTheme.appBackgroundColor()
        self.btnUploadResults.isUserInteractionEnabled = true
        // self.navigationController?.navigationBar.topItem?.title = self.back
        let array: Array<Any>? = UserDefaults.standard.value(forKey: "downloadSurveysArray") as? Array<Any>
        if (array?.count)! > 0 {
            // show from passed content
            setUpViews()
        } else {
            // take from dB
            self.surveySelected = CollabrateDB.sharedInstance().getSurvey(surveyID)
            setUpViews()
        }
        self.setOfflineCounter()
    }

    // MARK: - Generic Private Methods
     func updateSurveyPendingInDB() {
      //  CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Pending")      Thamarai dB
        CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Pending", withDownloadStatus: 99)
    }

    func setBorder(view: UIView) {
        view.layer.borderWidth = 1
        let borderColor = UIColor(red: 215/255.0, green: 216/255.0, blue: 217/255.0, alpha: 1.0)
        view.layer.borderColor = borderColor.cgColor
    }

    func setUpViews() {
        btnUploadResults.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
        btnTakeTrail.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
        self.view.layoutIfNeeded()
        btnTakeSurvey.backgroundColor = AppTheme.appBackgroundColor()
        btnTakeSurvey.layer.cornerRadius = 0.5 * btnTakeSurvey.bounds.size.width
        lblSurveyName?.text = surveySelected?.surveyName
        lblSurveyStatus?.text = NSLocalizedString((surveySelected?.surveyDescription)!, comment: "")
        let startDateString = self.formatDate(dateString: (self.surveySelected?.startDate)!)
        let endDateString = self.formatDate(dateString: (self.surveySelected?.endDate)!)
        if (startDateString == "7 Oct 2100") || (endDateString == "9 Oct 2100") {         // Default date value in case of Null or empty
            lblSurveyDate?.text = NSLocalizedString("Unscheduled", comment: "")
        }
        else {
            let dateRange = startDateString + " - " + endDateString
            lblSurveyDate?.text = dateRange
        }

        let approxString = NSLocalizedString("Approximately", comment: "") + " " + (self.surveySelected?.estimatedTime.stringValue)! + " " +  NSLocalizedString("min", comment: "")
        lblSurveyETA?.text = approxString
        lblNumberOfTimes?.text = NSLocalizedString("Surveys to upload", comment: "")
        self.setBorder(view: self.dateView!)
        self.setBorder(view: self.approxTimeView!)
        self.setBorder(view: self.numberOfTimesView!)
        self.view.layoutIfNeeded()
    }

    func setOfflineCounter() {
        var count: NSNumber = 0
        DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()

                count = sdk.getOfflineSurveyCount(self.surveySelected?.surveyID)
                DispatchQueue.main.async {
                        self.surveyCounter = count
                        self.lblCounter?.text = self.surveyCounter?.stringValue               // set counter
                        if (self.surveyCounter?.intValue)! > 0 {
                            CollabrateDB.sharedInstance().updateSurvey(self.surveySelected?.surveyID, withStatus: "Upload Results", withDownloadStatus: 99)
                        }
                }
        }
    }

    func formatDate(dateString: String) -> String {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.date(from: dateString)                   // create   date from string
        dateFormatter.dateFormat = "d MMM yyyy"
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }

    @objc func updateProgressBar(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let percentage  = userInfo["percentage"] as? Float,
            let _ = userInfo["numberOfFilesPending"] as? Int else {
                print("No userInfo found in notification")
                return
        }

        DispatchQueue.main.async {
                self.progressView.progress = percentage
                if percentage == 1.0 {
                    self.progressView.progress = 0.0
                    // change survey status in the present screen
                    self.lblSurveyStatus?.text = NSLocalizedString("Completed", comment: "")
                    self.setOfflineCounter()
                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Results are Uploaded", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
                    self.btnUploadResults.isUserInteractionEnabled = true
                }
        }
    }


    // MARK: - IBAction Methods
     @IBAction func takeSurveyAction(_ sender: UIButton) {
        let survey: OPGSurvey = CollabrateDB.sharedInstance().getSurvey(surveySelected?.surveyID)
        if survey.isOfflineDownloaded == 2 {
            self.updateSurveyPendingInDB()
            self.performSegue(withIdentifier: "takeOfflineSurvey", sender: self)
        }
        else {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Downloading. Please wait!", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))

        }
    }

    @IBAction func uploadResults(_ sender: Any) {
        if super.isOnline() {
            if self.surveyCounter == 0 || self.surveyCounter == nil {           // check if survey is taken at least once
                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please take the survey before uploading results.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                return
            }
            DispatchQueue.main.async {
                self.progressView.progress = 0.05             // show some inital progress to make the progress bar visible
            }
            self.btnUploadResults.isUserInteractionEnabled = false              // disable upload button until upload is over to avoid double tap.
            DispatchQueue.global(qos: .default).async {
                    let upload = UploadSurvey.sharedInstance
                    let panellistID: String = UserDefaults.standard.value(forKey: "PanelListID") as! String
                    upload.uploadOfflineSurvey(self.surveySelected!.surveyID, panelistID: panellistID, index: self.selectedSurveyIndex!)
            }
        }
        else {
            super.showNoInternetConnectionAlert()
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takeOfflineSurvey" {
            URLCache.shared.removeAllCachedResponses()
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
            let viewController: SurveyViewController = segue.destination as! SurveyViewController
            viewController.surveyReference = surveySelected?.surveyReference
            viewController.surveySelected = self.surveySelected
        }
    }
}
