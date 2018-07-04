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
    var didSurveyComplete: Bool = false
    var surveyReference: NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.appBackgroundColor()
        self.spinner.color = AppTheme.appBackgroundColor()
        self.spinner.startAnimating()
        self.surveyDelegate = self
        self.navigationController?.navigationBar.isHidden = false
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        if surveyReference != nil {
            self.loadSurvey(self.surveyReference! as String)
        }
    }



    @objc func back() {
    self.dismiss(animated: true, completion: nil) }

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
