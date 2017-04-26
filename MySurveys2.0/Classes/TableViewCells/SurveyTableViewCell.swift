//
//  SurveyTableViewCell.swift
//  DemoSurveys
//
//  Created by OnePoint Global on 07/04/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

import Foundation
import UIKit

class SurveyTableViewCell : UITableViewCell
{
    @IBOutlet weak var lblSurveyName : UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var btnSurveyDesc: UIButton!
    @IBOutlet weak var offlineFileCountButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView?
    @IBOutlet weak var constarintCounterBtnSpace: NSLayoutConstraint!
    var parentObject: HomeViewController?
    var index: IndexPath?
    var isDownloadStarted: Bool = false


    // MARK: - Localization Strings
    let download = NSLocalizedString("Downloading...", comment: "Downloading...")
    let new = NSLocalizedString("New", comment: "New")
    let completed = NSLocalizedString("Completed", comment: "Completed")

    func fillCell(_ survey: OPGSurvey)
    {
        let labelColor = UIColor(red:236/255.0, green:236/255.0, blue:236/255.0, alpha: 1.0)
        selectButton.layer.cornerRadius = 0.5 * selectButton.bounds.size.width
        offlineFileCountButton.layer.cornerRadius = 0.5 * offlineFileCountButton.bounds.size.width

        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            self.selectButton.setImage(UIImage(named : "survey_nav_iPad.png"), for: .normal)
        }

        
        if survey.surveyDescription == "xyz"
        {
            self.lblSurveyName.backgroundColor = labelColor
            self.btnSurveyDesc.backgroundColor = labelColor
            self.lblSurveyName.text="                  "
            self.btnSurveyDesc.setTitle("         ",for: .normal)
            self.selectButton.backgroundColor = labelColor
            self.progressBar?.progress = 0.0
            self.offlineFileCountButton.isHidden = true         //hide counter when shimmering
        }
        else
        {
            self.lblSurveyName.backgroundColor = UIColor.clear
            self.btnSurveyDesc.backgroundColor = UIColor.clear
            self.lblSurveyName.text=survey.surveyName
            if survey.isOffline == 1 {
                if survey.isOfflineDownloaded == 2 {
                    self.btnSurveyDesc.setTitleColor(UIColor.lightGray, for: .normal)
                    self.btnSurveyDesc.setTitle(survey.surveyDescription,for: .normal)
                    self.progressBar?.progress = 0.0
                    if (survey.surveyDescription == "Upload Results") || (survey.surveyDescription == "Uploading") {
                        self.btnSurveyDesc.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
                    }
                    
                } else if survey.isOfflineDownloaded == 1  {
                    self.btnSurveyDesc.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
                    self.btnSurveyDesc.setTitle("Downloading..."/*survey.surveyDescription*/,for: .normal)
                  //      test download thamarai
                } else if survey.isOfflineDownloaded == 0  {
                    self.btnSurveyDesc.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
                    self.btnSurveyDesc.setTitle(survey.surveyDescription,for: .normal)
                }
                
            } else  {
                self.btnSurveyDesc.setTitle(survey.surveyDescription,for: .normal)
                self.btnSurveyDesc.setTitleColor(UIColor.lightGray, for: .normal)
                self.progressBar?.progress = 0.0
            }
            self.selectButton.backgroundColor = AppTheme.appBackgroundColor()
            
        }
    }

    
    func fillCellGeoFenced(_ survey : OPGGeoFencingModel) {
        selectButton.layer.cornerRadius = 0.5 * selectButton.bounds.size.width
        print("Geo check! For \(survey.surveyName) it is \(survey.isDeleted)")
        if survey.isDeleted == 2 {                                              // isDeleted is used for Enter/Exit operations
            self.selectButton.backgroundColor = AppTheme.appBackgroundColor()
            self.lblSurveyName.backgroundColor = UIColor.clear
            self.btnSurveyDesc.backgroundColor = UIColor.clear
            self.lblSurveyName.text=survey.surveyName
            self.btnSurveyDesc.setTitle(survey.createdDate,for: .normal)
            if (survey.createdDate == "Upload Results") || (survey.createdDate == "Uploading") {
                self.btnSurveyDesc.setTitleColor(AppTheme.appBackgroundColor(), for: .normal)
            } else {
                self.btnSurveyDesc.setTitleColor(UIColor.lightGray, for: .normal)
            }
        } else {
            self.lblSurveyName.backgroundColor = UIColor.clear
            self.btnSurveyDesc.backgroundColor = UIColor.clear
            self.selectButton.backgroundColor = UIColor.lightGray
            self.lblSurveyName.text=survey.surveyName
            self.btnSurveyDesc.setTitle(survey.createdDate,for: .normal)
        }
        
    }
}
