//
//  ChangePanelViewController.swift
//  MySurveys2.0
//
//  Created by ThamaraiD on 24/10/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//


import Foundation

let selectedPanelName = "SelectedPanelName"
let selectedPanelID = "SelectedPanelID"
let tableViewCell = "panelTableViewCell"
let selectedTheme = "SelectedTheme"
let selectedThemeTemplateID = "selectedThemeTemplateID"



class ChangePanelViewController: RootViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var panelTableView: UITableView?
    @IBOutlet weak var lblPanelname: UILabel?
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var lblCurrentPanel: UILabel!
    
    var panelsArray: Array<OPGPanel> = []

    // MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Change Panel", comment: "ChangePanel")
        self.lblCurrentPanel.text = NSLocalizedString("Current Panel", comment: "")
        getPanelsfromDB()
    }
    
    // MARK: - Generic Private Methods
    func getPanelsfromDB() {
        panelsArray = (CollabrateDB.sharedInstance().getPanels() as? Array<OPGPanel>)!
        if panelsArray.count > 0 {
            let panelName: String? = UserDefaults.standard.value(forKey: selectedPanelName) as? String
            let panelID: String? = UserDefaults.standard.value(forKey: selectedPanelID) as? String
            
            if panelName != nil && panelID != nil {
                lblPanelname?.text = UserDefaults.standard.value(forKey: selectedPanelName) as! String?
            } else {
                let panel: OPGPanel = panelsArray.first!
                lblPanelname?.text = panel.panelName
                UserDefaults.standard.set(String(describing: panel.panelID!), forKey: selectedPanelID)
                UserDefaults.standard.set(String(describing: panel.themeTemplateID!), forKey: selectedThemeTemplateID)
                UserDefaults.standard.set(panel.panelName, forKey: selectedPanelName)
                UserDefaults.standard.synchronize()
            }
        }
    }

    // MARK: - UITableView Delegates

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 260.0
        } else {
            return 182.0
        }

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if panelsArray.count > 0 {
            return panelsArray.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paneltableViewCell: ChangePanelTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell) as! ChangePanelTableViewCell
        paneltableViewCell.tag = indexPath.row
        paneltableViewCell.selectionStyle =  UITableViewCellSelectionStyle.gray
        paneltableViewCell.fillCell(panel: panelsArray[indexPath.row])
        let logoID: NSNumber  = self.panelsArray[indexPath.row].logoID as NSNumber
        let mediaID: NSNumber = self.panelsArray[indexPath.row].mediaID as NSNumber
        let logoUrl: String? = self.panelsArray[indexPath.row].logoUrl
        let mediaUrl: String? = self.panelsArray[indexPath.row].mediaUrl
        if logoUrl != "" {
            // load the logo image from cache folder if image available else hit API and get it
            let path  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationFolderPath = path.appending("/PanelImages") as String
            let logoImagePath = destinationFolderPath.appending("/\(self.panelsArray[indexPath.row].logoID!).png")
            if !(FileManager.default.fileExists(atPath: logoImagePath)) {
                // call API n get the image
                if let url = logoUrl {
                    let urlRequest = NSURLRequest(url: NSURL(string: url) as! URL)
                    let task = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            if let img = image {
                                self.saveImagetoCache(img, logoID)
                                DispatchQueue.main.async {
                                    if paneltableViewCell.tag == indexPath.row {
                                        paneltableViewCell.imgPanelImage?.image = img
                                    }
                                }
                            }
                        }
                    })
                    task.resume()
                }
            } else {
                // load from cache
                if paneltableViewCell.tag == indexPath.row {
                    paneltableViewCell.imgPanelImage?.image  = UIImage(contentsOfFile: logoImagePath)
                }
            }
        }
        if mediaUrl != "" {
            // load the panel background image from cache folder if image available else hit API and get it
            let path  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationFolderPath = path.appending("/PanelImages") as String
            let bgImagePath = destinationFolderPath.appending("/\(self.panelsArray[indexPath.row].mediaID!).png")
            if !(FileManager.default.fileExists(atPath: bgImagePath)) {
                // call API n get the image
                if let mediaurl = mediaUrl {
                    let urlRequest = NSURLRequest(url: NSURL(string: mediaurl) as! URL)
                    let task = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            if let img = image {
                                self.saveImagetoCache(img, mediaID)
                                DispatchQueue.main.async {
                                    if paneltableViewCell.tag == indexPath.row {
                                        paneltableViewCell.imgBackgroundView?.image  = img
                                    }
                                }
                            }

                        }
                    })
                    task.resume()
                }
            } else {
                // load from cache
                if paneltableViewCell.tag == indexPath.row {
                    paneltableViewCell.imgBackgroundView?.image  = UIImage(contentsOfFile: bgImagePath)
                }
            }
        }
        paneltableViewCell.selectionStyle = UITableViewCellSelectionStyle.default
        return paneltableViewCell
    }

    func saveImagetoCache(_ image: UIImage, _ fileName: NSNumber) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let destinationFolderPath = path.appending("/PanelImages") as String
        if !(FileManager.default.fileExists(atPath: destinationFolderPath)) {
            do {
                try FileManager.default.createDirectory(atPath: destinationFolderPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // save image with panel name
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let desPath = NSURL(fileURLWithPath: destinationFolderPath.appending("/\(fileName).png"))
            do {
                try data.write(to: desPath as URL, options: .atomic)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCell = tableView.cellForRow(at: indexPath)!
        tableViewCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        if panelsArray.count > 0 {
            let panelSelected: OPGPanel = panelsArray[indexPath.row] as OPGPanel
            lblPanelname?.text = panelSelected.panelName
            UserDefaults.standard.set(String(describing: panelSelected.panelID!), forKey: selectedPanelID)
            UserDefaults.standard.set(String(describing: panelSelected.themeTemplateID!), forKey: selectedThemeTemplateID)
            UserDefaults.standard.set(panelSelected.panelName, forKey: selectedPanelName)
            UserDefaults.standard.synchronize()

            let panelIdStr = UserDefaults.standard.value(forKey: selectedPanelID) as? String
            let themeTempID: String? = UserDefaults.standard.value(forKey: selectedThemeTemplateID) as? String
            let dict = CollabrateDB.sharedInstance().getThemesForPanelID(panelIdStr, themeTemplateID: themeTempID)
            if (dict?.count)!>0 {
                AppTheme.setCurrentTheme(theme: dict!)
                self.navigationController?.navigationBar.barTintColor = AppTheme.appBackgroundColor()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
