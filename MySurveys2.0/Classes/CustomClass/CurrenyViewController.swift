//
//  CurrenyViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 23/01/18.
//  Copyright © 2018 Chinthan. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        print("\(amountWithPrefix)")
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double: Double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        print("number \(number)")
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}

@objc protocol CurrencyViewDelegate: class {
    func currencyProcessCompleted(_ text: String?)
}

class CurrenyViewController: UIViewController {

    @objc weak var delegate: CurrencyViewDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var okButton: UIButton!

    @objc var currencyVal: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        textField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
         let curVal = Double(currencyVal!)
        textField.text = String(format: "%.2f", curVal!)
        self.navigationController?.navigationBar.barTintColor = AppTheme.appBackgroundColor()
        self.okButton.backgroundColor = AppTheme.appBackgroundColor()
       

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            let amount = amountString.replacingOccurrences(of: ",", with: "")
            textField.text = amount
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        textField.resignFirstResponder()
        self.delegate?.currencyProcessCompleted(textField.text)
        self.dismiss(animated: true, completion: nil)
    }

}
