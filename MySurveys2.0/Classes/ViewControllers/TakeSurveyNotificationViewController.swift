//
//  TakeSurveyNotificationViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 09/11/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit

class TakeSurveyNotificationViewController: RootViewController, UITextViewDelegate {

    @IBOutlet weak var txtNotificationDesc: UITextView!
    @IBOutlet weak var btnTakeSurvey: UIButton!


    var surveyReference: NSString!
    var notificationDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNotificationDesc.delegate=self
        self.view.layoutIfNeeded()
        self.btnTakeSurvey.layer.cornerRadius = 0.5 * btnTakeSurvey.bounds.size.width
        self.btnTakeSurvey.backgroundColor = AppTheme.appBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeSurveyAction(_ sender: Any) {
        print("Taking Survey")
        self.performSegue(withIdentifier: "TakeNotificationSurvey", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TakeNotificationSurvey" {
            // Get Survey view
            let viewController: SurveyViewController = segue.destination as! SurveyViewController
            // viewController.surveyReference=self.surveyReference as String
            // viewController.surveyReference="SDKDemo"
        }
    }

}
