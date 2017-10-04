//
//  ProfileTableViewCell.swift
//  MySurveys2.0
//
//  Created by Manjunath on 25/10/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var constarintNameTopSpace: NSLayoutConstraint!
    @IBOutlet weak var constarintNameToLabelTopSpace: NSLayoutConstraint!

    var editedName: String = ""
    var editedCountry: String = ""
    var panelist: OPGPanellistProfile!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtValue.delegate=self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(title: String, value: String, tagIdentifier: Int) {
        lblTitle.text = title
        txtValue.text = value
        txtValue.tag = tagIdentifier
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   // delegate method
        textField.resignFirstResponder()
        return true
    }    

}
