//
//  SettingsTableViewCell.swift
//  MySurveys2.0
//
//  Created by Chinthan on 24/10/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewCell : UITableViewCell {
    @IBOutlet weak var lblSettingsItems: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    func fillCell(items: String, isGeoFencing: Bool)
    {
        if isGeoFencing == true {
            let isGeoFence = UserDefaults.standard.value(forKey: "isGeoFenced") as? String
            switchControl.isHidden = false
            if isGeoFence == "1" {
                switchControl.setOn(true, animated: true)
            } else {
                switchControl.setOn(false, animated: true)
            }
        }
        lblSettingsItems.text = items
    }
}
