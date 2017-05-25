//
//  SurveyDetailsViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 16/08/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit

class SurveyDetailsViewController: RootViewController {

    @IBOutlet weak var lblSurveyName: UILabel?
    @IBOutlet weak var lblSurveyStatus : UILabel?
    @IBOutlet weak var btnTakeSurvey : UIButton!
    @IBOutlet weak var btnTakeTrail : UIButton!
    @IBOutlet weak var lblSurveyDate: UILabel?
    @IBOutlet weak var lblSurveyETA: UILabel?

    @IBOutlet weak var dateView : UIView?
    @IBOutlet weak var approxTimeView : UIView?
    var surveyID : NSNumber?
    var surveySelected : OPGSurvey?

     // MARK: - IBAction methods
    @IBAction func takeSurveyAction(_ sender: UIButton)
    {
        if super.isOnline()
        {
            self.updateSurveyPendingInDB()
            self.performSegue(withIdentifier: "embedTakeSurvey", sender: self)
        }
        else
        {
            super.showNoInternetConnectionAlert()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.hidesBarsOnSwipe = false
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            self.btnTakeSurvey.setImage(UIImage(named : "surveydetail_nav_iPad.png"), for: .normal)
        }

    }

    func setBorder(view : UIView)
    {
        view.layer.borderWidth = 1
        let borderColor = UIColor(red:215/255.0, green:216/255.0, blue:217/255.0, alpha: 1.0)

        view.layer.borderColor = borderColor.cgColor
    }
    
    func setUpViews() {
        self.view.layoutIfNeeded()
        btnTakeTrail.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
        btnTakeSurvey.backgroundColor = AppTheme.appBackgroundColor()
        btnTakeSurvey.layer.cornerRadius = 0.5 * btnTakeSurvey.bounds.size.width
        lblSurveyName?.text = surveySelected?.surveyName
        lblSurveyStatus?.text = NSLocalizedString((surveySelected?.surveyDescription)!, comment: "")
        let approxString = NSLocalizedString("Approximately", comment: "") + " " + (self.surveySelected?.estimatedTime.stringValue)! + " " +  NSLocalizedString("min", comment: "min")
        lblSurveyETA?.text = approxString

        let startDateString = self.formatDate(dateString: (self.surveySelected?.startDate)!)
        let endDateString = self.formatDate(dateString: (self.surveySelected?.endDate)!)
        
        if ((startDateString == "6 Oct 2100") || (endDateString == "9 Oct 2100"))
        {
            lblSurveyDate?.text = "Unscheduled"                 //temporary for unscheduled surveys
        }
        else
        {
            let dateRange = startDateString + " - " + endDateString
            lblSurveyDate?.text = dateRange
        }
        self.setBorder(view: self.dateView!)
        self.setBorder(view: self.approxTimeView!)
        self.view.layoutIfNeeded()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Back", comment: "Back")
        self.navigationItem.title = NSLocalizedString("Survey", comment: "Survey")
        
        let array : Array<Any>? = UserDefaults.standard.value(forKey: "downloadSurveysArray") as? Array<Any>
        if ((array?.count)! > 0) {
            // show from passed content
            setUpViews()
            
        } else {
            // take from dB
            self.surveySelected = CollabrateDB.sharedInstance().getSurvey(surveyID)
            setUpViews()
            
        }

      /**  if surveyID != nil {     thamarai changes
            self.surveySelected = CollabrateDB.sharedInstance().getSurvey(surveyID)
            setUpViews()
        }*/
    }

    func formatDate(dateString : String) -> String
    {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)                   // create   date from string
        dateFormatter.dateFormat = "d MMM yyyy"
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    func updateSurveyPendingInDB() {
       // CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Pending")
        CollabrateDB.sharedInstance().updateSurvey(surveySelected?.surveyID, withStatus: "Pending", withDownloadStatus: 99)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if(segue.identifier == "embedTakeSurvey")
        {
            let viewController : SurveyViewController = segue.destination as! SurveyViewController
            viewController.surveyReference = surveySelected?.surveyReference
            viewController.surveySelected = self.surveySelected
        }
    }
 

}
