//
//  ShowNotificationViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 09/11/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit

class ShowNotificationViewController: RootViewController, UITextViewDelegate
{

    @IBOutlet weak var txtNotificationDesc: UITextView!
    var notificationDescription : String?


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtNotificationDesc.delegate=self
        self.txtNotificationDesc.text = self.notificationDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
