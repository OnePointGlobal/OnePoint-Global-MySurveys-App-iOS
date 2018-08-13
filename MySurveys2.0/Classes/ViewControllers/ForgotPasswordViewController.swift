//
//  ForgotPasswordViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 09/12/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: RootViewController, UITextFieldDelegate {

    // MARK: - IBOutlets for view
    @IBOutlet weak var btnSubmit: UIButton?
    @IBOutlet weak var txtEmailID: UITextField?
    @IBOutlet weak var lblForgotYourPassword: UILabel?
    @IBOutlet weak var lblWeWillEmail: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var constraintViewTop: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailFieldTopSpace: NSLayoutConstraint!
    @IBOutlet weak var emailToLabelTopSpace: NSLayoutConstraint!
    @IBOutlet weak var forgotYourPasswordBottomSpace: NSLayoutConstraint!

    // MARK: - Properties of viewcontroller
    var bgColor: UIColor?


    // MARK: - View delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblWeWillEmail?.text = NSLocalizedString("We will email you a link to reset your Password", comment: "")
        self.lblForgotYourPassword?.text = NSLocalizedString("Forgot your password?", comment: "")
        self.txtEmailID?.delegate = self
        self.txtEmailID?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("E-mail Id", comment: "email"),
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 178/255.0, green: 176/255.0, blue: 178/255.0, alpha: 1.0)])
        self.btnSubmit?.setTitleColor(self.bgColor, for: .normal)
        self.btnSubmit?.layer.borderColor = self.bgColor?.cgColor
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.btnSubmit?.layer.borderWidth = 1.0
        }
        else {
            self.btnSubmit?.layer.borderWidth = 1.3
        }
        self.btnSubmit?.setTitle(NSLocalizedString("Send", comment: "Send"), for: .normal)
        self.activityIndicator.color = self.bgColor
        self.view.backgroundColor = self.bgColor
        self.bgView.backgroundColor = self.bgColor
    }

    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            if width == OPGConstants.device.iPadLandscapeWidth || width == OPGConstants.device.iPadRetinaLandscapeWidth {
                self.setConstraintsForiPadLandscape()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.hidesBarsOnSwipe = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.txtEmailID?.resignFirstResponder()
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            // self.setBackgroundImageforView()
            self.txtEmailID?.becomeFirstResponder()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Private methods
    func sendForgotPassword(mail: String) {
        if isValidEmail(mailID: mail) {
            self.activityIndicator.startAnimating()
            DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                var forgotPassword: OPGForgotPassword
                do {
                    forgotPassword = try sdk.forgotPassword(mail) as OPGForgotPassword
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        if forgotPassword.isSuccess == 1 {
                            self.txtEmailID?.text = ""
                            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Success! Please check your e-mail for new password!", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                        }
                        else {
                            if forgotPassword.httpStatusCode.intValue == 400 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enter a valid e-mail ID.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else if forgotPassword.httpStatusCode.intValue == 200 && forgotPassword.statusMessage == "Email Id does not exist" {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("E-mail Id does not exist", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else if forgotPassword.httpStatusCode.intValue == 406 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enter a valid e-mail ID.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else if forgotPassword.httpStatusCode.intValue == 404 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("E-mail Id not found.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else if forgotPassword.httpStatusCode.intValue == 500 {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Internal Server Error", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                            else {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("An error occurred while trying to send an email to reset the password.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                            }
                        }
                    }
                }
                catch let err as NSError {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        print("Error: \(err)")
                    }
                }
            }
        }
        else {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enter a valid e-mail ID.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
        }
    }

    func isValidEmail(mailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: mailID)
    }

    func setConstraintsForiPadLandscape() {
        UIView.animate(withDuration: 0.5, animations: {
        self.constraintViewTop.constant = 0
        self.emailFieldTopSpace.constant = 60
        self.emailToLabelTopSpace.constant = 50.0
        self.view.layoutIfNeeded()
        })
    }


    // MARK: - IBAction Methods
    @IBAction func forgotPasswordAction(_ sender: AnyObject) {
        if self.txtEmailID?.text == nil ||  self.txtEmailID?.text == "" {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enter your e-mail ID", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
        } else {
            if super.isOnline() {
                self.sendForgotPassword(mail: (txtEmailID?.text)!)
            }
            else {
                super.showNoInternetConnectionAlert()
            }
        }
    }

    // MARK: - Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        let height = self.view.bounds.height
        let width = self.view.bounds.width

        if UIDevice.current.userInterfaceIdiom == .phone {
            if height > OPGConstants.device.iPhone4Height {
                UIView.animate(withDuration: 0.5, animations: {
                    self.constraintViewTop.constant = -70.0
                    self.view.layoutIfNeeded()
                })
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.constraintViewTop.constant = -130.0
                    self.view.layoutIfNeeded()
                })
            }
        }
        else {
            // iPad landscape
            if width == OPGConstants.device.iPadLandscapeWidth || width == OPGConstants.device.iPadRetinaLandscapeWidth {
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailFieldTopSpace.constant = 5.0
                    self.emailToLabelTopSpace.constant = 5.0
                    self.constraintViewTop.constant = -30.0
                    self.forgotYourPasswordBottomSpace.constant = 15.0
                    self.view.layoutIfNeeded()
                })
            }
            else if width == OPGConstants.device.iPadPortraitWidth || width == OPGConstants.device.iPadRetinaPortraitWidth {
                // iPad portrait
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailFieldTopSpace.constant = 125.0
                    self.forgotYourPasswordBottomSpace.constant = 30.0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if height == OPGConstants.device.iPadPortraitHeight || height == OPGConstants.device.iPadRetinaPortraitHeight {
                        // iPad portarit
                        self.constraintViewTop.constant = 30
                        // self.emailFieldTopSpace.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    else {
                        // iPad landscape
                        self.constraintViewTop.constant = 0
                        self.emailFieldTopSpace.constant = 20
                        self.emailToLabelTopSpace.constant = 80.0
                        self.view.layoutIfNeeded()
                    }
                }
                else {
                    // iPhone
                    self.constraintViewTop.constant = 0
                    self.emailFieldTopSpace.constant = 20
                    self.view.layoutIfNeeded()
                }
        })
    }
}
