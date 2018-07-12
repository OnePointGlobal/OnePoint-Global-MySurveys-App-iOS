//
//  TakeTrialViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 25/06/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

import UIKit

class TakeTrialViewController: OPGViewController, OPGSurveyDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var surveyReference: NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = NSLocalizedString("Survey", comment: "Survey")
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = UIBarStyle.black
        navBar?.tintColor = UIColor.white
        navBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.view.backgroundColor = AppTheme.appBackgroundColor()
        self.spinner.color = AppTheme.appBackgroundColor()
        self.spinner.startAnimating()
        self.surveyDelegate = self
        if surveyReference != nil {
            self.loadSurvey(self.surveyReference! as String)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - WebView methods
    func didSurveyStartLoad() {
        print("QUESTION STARTED LOADING")
        self.spinner.startAnimating()
        self.spinner.isHidden = false
    }

    func didSurveyFinishLoad() {
        print("QUESTION FINISHED LOADING")
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }

    func didSurveyCompleted() {
        print("SURVEY COMPLETED")
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        // get a reference to the app delegate
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.resetLoginRootView()

    }
}
