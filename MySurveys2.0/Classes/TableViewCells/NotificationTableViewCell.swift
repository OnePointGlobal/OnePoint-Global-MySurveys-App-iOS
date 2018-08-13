//
//  NotificationTableViewCell.swift
//  MySurveys2.0
//
//  Created by Manjunath on 09/11/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblNotificationDesc: UILabel!
    @IBOutlet weak var imgNavigation: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: - IBOutlet Action methods
    @IBAction func selectNotification(_ sender: Any) {
        
    }
}
