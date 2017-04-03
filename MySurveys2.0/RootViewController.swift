//
//  RootViewController.swift
//  MySurveys2.0
//
//  Created by ThamaraiD on 27/10/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    
    func isOnline() -> Bool {
        let reachability: OPGReachability = OPGReachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
        
    }
    
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoInternetConnectionAlert() {
        let alert = UIAlertController(title: "Connection Lost", message: "Request cannot be completed, as you're not connected to Internet.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
