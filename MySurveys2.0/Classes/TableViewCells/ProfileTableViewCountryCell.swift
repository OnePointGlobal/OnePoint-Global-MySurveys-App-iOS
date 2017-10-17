//
//  ProfileTableViewCountryCell.swift
//  MySurveys2.0
//
//  Created by Manjunath on 16/11/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit

class ProfileTableViewCountryCell: UITableViewCell {

    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(title: String, value: String) {
        lblCountry.text = title
        lblCountryName.text = value
    }
}
