//
//  ChangePanelTableViewCell.swift
//  MySurveys2.0
//
//  Created by ThamaraiD on 28/10/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import Foundation

class ChangePanelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgBackgroundView: UIImageView?
    @IBOutlet weak var imgPanelImage: UIImageView?
    @IBOutlet weak var lblPanelName: UILabel?
    
    
    func fillCell(panel: OPGPanel) {
        lblPanelName?.text = panel.panelName
        imgBackgroundView?.image = UIImage(named: "default_panel_bg.png")
        imgPanelImage?.image = UIImage(named: "default_theme_image.png")
    }
    
}
