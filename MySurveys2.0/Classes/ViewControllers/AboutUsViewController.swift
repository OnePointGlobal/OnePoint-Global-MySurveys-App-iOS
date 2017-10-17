//
//  AboutUsViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 13/06/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit

/*
This controller loads the web URL for displaying pages like T&C, Privacy and About Us.
*/
class AboutUsViewController: RootViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var urlString: String?
    var pageTitle: String?
    
    // MARK: - View Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.title = pageTitle
        self.activityIndicator.color = AppTheme.appBackgroundColor()
        if super.isOnline() {
            self.activityIndicator.startAnimating()
            if let urlStr = self.urlString {
                let url = NSURL(string: urlStr)
                if let urlS = url {
                    webView.loadRequest(NSURLRequest(url: urlS as URL) as URLRequest)
                }
            }
        }
        else {
            super.showNoInternetConnectionAlert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Webview Delegates
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }
    
}
