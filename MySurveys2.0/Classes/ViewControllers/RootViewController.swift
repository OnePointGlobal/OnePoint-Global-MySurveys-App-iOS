//
//  RootViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 27/10/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation
import UIKit

/*
 This is the parent class for all other view controllers.
 */
class RootViewController: UIViewController {

    ///
    /**
    Method to check internet connectivity.
    - returns: A boolean value indicating the status of internet connectivity.
    */
    func isOnline() -> Bool {
        let reachability: OPGReachability = OPGReachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }


    /**
    Common alert method used by all view controllers
    - parameter alertTitle: Title of the alert view
    - parameter alertMessage: Alert display message
    - parameter alertAction: Alert action button title. Eg: OK
    */
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /// Show alert indicating no internet.
    func showNoInternetConnectionAlert() {
        self.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("No internet connection. Please try again!", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
    }

    /// Configures Navigation bar.
    func setNavigationBarTheme() {
        self.navigationController?.navigationBar.isTranslucent = true
        let navAlpha = 0.85 // Your appropriate calculation
        let image = UIImage.imageFromColor(color: AppTheme.appBackgroundColor().withAlphaComponent(CGFloat(navAlpha)))
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barStyle = .default
    }

}
