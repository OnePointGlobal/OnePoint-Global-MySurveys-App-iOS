//
//  IntermediateTrialSurveyViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 05/07/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

import UIKit

class IntermediateTrialSurveyViewController: RootViewController, UINavigationControllerDelegate {
    var surveyReference: NSString?


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil{
            self.navigationController?.delegate = self 
        }
        else {
            print("navigation controller does not exist")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if super.isOnline() {
            if self.surveyReference != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "show_trial", sender: nil)
                }
            }
        }
        else {
            let alert = UIAlertController(title: NSLocalizedString("MySurveys", comment: "App Name"), message: NSLocalizedString("No internet connection. Please try again!", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.default, handler: {
                    action in self.gotoLoginPage()
                }))
                self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController.isEqual(self) {
            self.viewDidAppear(animated)
        }
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isEqual(self) {
            self.viewWillAppear(animated)
        }
    }


    func gotoLoginPage() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.resetLoginRootView()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_trial" {
            // Get common web view
            let viewController: TakeTrialViewController = segue.destination as! TakeTrialViewController
            viewController.surveyReference = self.surveyReference
        }
    }
}
