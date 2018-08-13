//
//  ShowNotificationViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 09/11/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit

class ShowNotificationViewController: RootViewController, UITextViewDelegate {

    @IBOutlet weak var txtNotificationDesc: UITextView!
    var notificationDescription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNotificationDesc.delegate = self
        self.txtNotificationDesc.text = self.notificationDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
