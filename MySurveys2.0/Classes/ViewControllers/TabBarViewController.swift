//
//  TabBarViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 15/06/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
        self.delegate = self
        self.navigationController?.navigationBar.isTranslucent = true

        // set localised tab bar titles at the load time
        self.tabBar.items?[0].title = NSLocalizedString("Survey", comment: "")
        self.tabBar.items?[1].title = NSLocalizedString("Notifications", comment: "")
        self.tabBar.items?[2].title = NSLocalizedString("Settings", comment: "")
        self.tabBar.items?[3].title = NSLocalizedString("Profile", comment: "")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // self.selectedIndex = 1
        UITabBar.appearance().tintColor = AppTheme.appBackgroundColor()
        self.tabBar.tintColor = AppTheme.appBackgroundColor()
        

    }

    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
        //self.tabBar.items?[1].badgeValue = "3"
        if item == ((self.tabBar.items?[0])! as UITabBarItem) {
            // Do something if index is 0
            self.navigationItem.hidesBackButton = true
            self.setThemeBGImage()
        }
        else if item == ((self.tabBar.items?[1])! as UITabBarItem) {
            // Do something if index is 1
            self.navigationItem.titleView = nil
            self.navigationItem.title = NSLocalizedString("Notifications", comment: "")
            self.navigationItem.hidesBackButton = true
            self.navigationItem.rightBarButtonItem = nil

        }
        else if item == ((self.tabBar.items?[2])! as UITabBarItem) {
            // Do something if index is 1
            self.navigationItem.titleView = nil
            self.navigationItem.title = NSLocalizedString("Settings", comment: "")
            self.navigationItem.rightBarButtonItem = nil
        }
        else if item == ((self.tabBar.items?[3])! as UITabBarItem) {
            // Do something if index is 1
            self.navigationItem.titleView = nil
            self.navigationItem.title = NSLocalizedString("Profile", comment: "")
            self.navigationItem.hidesBackButton = true
        }
    }

    func setThemeBGImage() {
        let headerLogoBGImagePath: String = AppTheme.getHeaderLogoImagePath()
        if headerLogoBGImagePath.isEmpty {
            let logoText: String = AppTheme.getLogoText()
            if logoText.isEmpty {
                // set default logo Image
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
                imageView.contentMode = .scaleAspectFit
                let image = UIImage(named: "applogo.png")
                imageView.image = image
                self.navigationItem.titleView = imageView
            }
            else {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
                label.numberOfLines = 1
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                label.text = logoText
                label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
                label.textColor = UIColor.white
                self.navigationItem.titleView = label
            }
        }
        else {
            let fileExists = FileManager().fileExists(atPath: headerLogoBGImagePath)
            if fileExists {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(contentsOfFile: headerLogoBGImagePath)           // set theme logo  image
                self.navigationItem.titleView = imageView
            }
        }
    }
}
