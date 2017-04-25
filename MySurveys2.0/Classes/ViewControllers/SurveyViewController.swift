//
//  SurveyViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 20/06/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//
class SurveyViewController: OPGViewController, OPGSurveyDelegate
{
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bgImage: UIImageView?
    
    var surveyReference: String?
    var surveySelected : OPGSurvey?
    var panelIdStr: String?
    var panellistIdStr: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    // MARK: - View Delegate methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.appBackgroundColor()
        self.spinner.startAnimating()
        self.surveyDelegate = self;

        if self.surveySelected?.isOffline == 0
        {

            self.panelIdStr = UserDefaults.standard.value(forKey: "SelectedPanelID") as? String
            self.panellistIdStr  = UserDefaults.standard.value(forKey: "PanelListID") as? String
            let panelNumber = self.stringToNSNumber(str: self.panelIdStr!)
            let panellistNumber = self.stringToNSNumber(str: self.panellistIdStr!)
            //self.loadSurvey(self.surveyReference)
            self.loadSurvey(self.surveyReference, panelID : panelNumber, panellistID: panellistNumber)
        }
        else
        {
            self.panelIdStr = UserDefaults.standard.value(forKey: "SelectedPanelID") as? String
            self.panellistIdStr  = UserDefaults.standard.value(forKey: "PanelListID") as? String

            let panelNumber = self.stringToNSNumber(str: self.panelIdStr!)
            let panellistNumber = self.stringToNSNumber(str: self.panellistIdStr!)
            self.loadOfflineSurvey(self.getScriptPath(), surveyName: self.surveySelected!.surveyName, surveyID: self.surveySelected!.surveyID ,panelID: panelNumber,panellistID: panellistNumber)
        }
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.backgroundColor = AppTheme.appBackgroundColor()
        appDelegate.shouldRotate = true         //Enable rotation on showing the view
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        appDelegate.shouldRotate = false        //disable rotation when leaving the view
    }

     // MARK: - Generic Private methods
    func stringToNSNumber(str:String) -> NSNumber
    {
        let intValue = Int(str)
        let numberValue : NSNumber  =  NSNumber(value:intValue!)
        return numberValue
    }

    func getScriptPath() ->String
    {
        let surveyID : NSNumber = self.surveySelected!.surveyID
        let surveyIDString = surveyID.stringValue
        let destPath : String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let scriptPath : String = (destPath.appending("/\(surveyIDString).opgs"));
        return scriptPath
    }

    func updateSurveyInDB() {
        if surveySelected?.isOffline == 0 {
          //  CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Completed")                 thamarai dB
            CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Completed", withDownloadStatus: 99)
        } else {
          //  CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Upload Results")            thamarai dB
            CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Upload Results", withDownloadStatus: 99)
        }
    }

    // MARK: - WebView methods
    func didSurveyStartLoad() {
        self.spinner.startAnimating()
        self.spinner.isHidden = false
    }
    
    func didSurveyFinishLoad() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true

    }
    
    func didSurveyCompleted() {
        updateSurveyInDB()
        _ = self.navigationController?.popViewController(animated: true)
    }


}
