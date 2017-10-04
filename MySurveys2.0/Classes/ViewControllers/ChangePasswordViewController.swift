//
//  ChangePasswordViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 24/10/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import Foundation

class ChangePasswordViewController: RootViewController, UITextFieldDelegate {
    // MARK: - IBOutlets for view
    @IBOutlet weak var lblEmail: UILabel?
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var constraintViewCentre: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties for viewcontroller
    var panelist: OPGPanellistProfile!


    // MARK: - View delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Change Password", comment: "pageTitle")
        self.activityIndicator.color = AppTheme.appBackgroundColor()
        txtOldPassword.delegate=self
        txtNewPassword.delegate=self
        txtConfirmPassword.delegate=self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setChangePasswordView()
        self.panelist = CollabrateDB.sharedInstance().getPanellistProfile()
        if self.panelist.email != nil {
            self.lblEmail?.text = self.panelist.email                           // set email label
        }
        else {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
        }
    }
    
    // MARK: - Generic Private Methods
    func setChangePasswordView() {
        txtOldPassword.placeholder = NSLocalizedString("Old Password", comment: "")
        txtNewPassword.placeholder = NSLocalizedString("New Password", comment: "")
        txtConfirmPassword.placeholder = NSLocalizedString("Confirm Password", comment: "")
        let placeHolderColor: UIColor = UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
        self.txtOldPassword!.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        self.txtNewPassword!.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        self.txtConfirmPassword!.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

        self.btnOK.setTitle((NSLocalizedString("OK", comment: "")), for: .normal)
        self.btnCancel.setTitle((NSLocalizedString("Cancel", comment: "")), for: .normal)
    }

    func resetUI() {
        self.txtOldPassword.text = ""
        self.txtNewPassword.text = ""
        self.txtConfirmPassword.text = ""
    }

    // MARK: - IBOutlet Action methods
    @IBAction func changePasswordAction(_ sender: AnyObject) {
        var changePassowrdObj: OPGChangePassword!
        if super.isOnline() == false {
            super.showNoInternetConnectionAlert()
            return
        }
        if (txtOldPassword.text?.isEmpty)! {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Old Password cannot be empty.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
            return
        }

        if (txtNewPassword.text?.isEmpty)! {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please enter your new password.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
            return
        }

        if (txtConfirmPassword.text?.isEmpty)! {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Please confirm your new password.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
            return
        }

        if (txtOldPassword.text?.isEqual(txtNewPassword.text))! {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Old and new passwords cannot be same", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
            return
        }
        if !(txtNewPassword.text?.isEqual(txtConfirmPassword.text))! {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("New and Confirm passwords should be same", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
            return
        }

        self.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .default).async {
                let sdk = OPGSDK()
                do {
                    changePassowrdObj = try sdk.changePassword(self.txtOldPassword.text, newPassword: self.txtNewPassword.text)
                    DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            if changePassowrdObj.isSuccess.boolValue == true {
                                super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Password changed successfully!", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
                                self.resetUI()
                            }
                            else {
                                if changePassowrdObj.httpStatusCode.intValue == 404 {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Current Password does not exist", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
                                }
                                else if changePassowrdObj.httpStatusCode.intValue == 500 {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Internal Server Error", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
                                }
                                else {
                                    super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("Oops! Unknown error. Please try again.", comment: ""), alertAction: NSLocalizedString("OK", comment: ""))
                                }
                            }
                    }
                }
                catch let err as NSError
                {
                    DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            print("Error: \(err)")
                    }
                }
        }
    }

    // Clears all the textfields in the view and pops the view controller
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.constraintViewCentre.constant = 0
            self.view.layoutIfNeeded()
        })
        self.resetUI()
        let _ = navigationController?.popViewController(animated: true)

    }

    // MARK: - UITextField Delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        if textField.tag == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.constraintViewCentre.constant = -50.0
                self.view.layoutIfNeeded()
            })

        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.constraintViewCentre.constant = 0
            self.view.layoutIfNeeded()
        })
    }

}
