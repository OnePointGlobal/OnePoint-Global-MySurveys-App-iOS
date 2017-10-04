//
//  CountriesListViewController.swift
//  MySurveys2.0
//
//  Created by Manjunath on 16/11/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit


// protocol used for sending data back
protocol CountryChangedDelegate: class {
    func userDidChangeCountry(newCountry: OPGCountry)
    func restoreEditMode()
}


class CountriesListViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    // MARK: - IBOutlets for View
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties for viewcontroller
    var countryArray: [OPGCountry] = []
    var countrySectionTitles: [String] = []
    var indexCountryDict = [String: Array<Any>]()
    var indexCharacters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y", "Z"]          // There is no X
    var arrayOfCountryNames: [String] = []
    weak var delegate: CountryChangedDelegate? = nil
    var navigationBar = UINavigationBar()
    
    // MARK: - viewcontroller delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.getCountries()
        self.tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.createNavBarforiPad(width: Int(view.frame.size.width))
        self.activityIndicator.color = AppTheme.appBackgroundColor()
        if super.isOnline() == false {
            self.activityIndicator.stopAnimating()
            super.showNoInternetConnectionAlert()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.restoreEditMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            let bounds = UIScreen.main.bounds
            self.createNavBarforiPad(width: Int(bounds.size.width))
        })
    }

    // MARK: - Generic Private Methods
     func createNavBarforiPad(width: Int) {
        self.navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 60))
       navigationBar.barTintColor = AppTheme.appBackgroundColor()
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        let navigationItem = UINavigationItem()             // Create a navigation item with a title
        navigationItem.title = NSLocalizedString("Country", comment: "Country")
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        navigationItem.leftBarButtonItem = leftButton
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }


    func getCountries() {
            self.tableView.backgroundView = self.activityIndicator
            DispatchQueue.global(qos: .default).async {
                    let sdk = OPGSDK()
                    do {
                        self.countryArray = try sdk.getCountries() as! [OPGCountry]
                        DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                if self.countryArray.count > 0 {
                                    self.populateCountryNames()
                                    self.buildCountryDictionary()
                                    self.tableView.reloadData()
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

    func populateCountryNames() {
        for country in self.countryArray {
            self.arrayOfCountryNames.append(country.name)
        }
    }

    func getFilteredArray(startChar: String) -> [String] {
        var sectionArray: [String] = []
        for name in self.arrayOfCountryNames {
            let subStrIndex: String.Index = name.index(name.startIndex, offsetBy: 1)
            let letterString = name.substring(to: subStrIndex)
            if letterString == startChar {
                sectionArray.append(name)
            }
        }
        return sectionArray
    }

    func buildCountryDictionary() {                 // Alphabet Key abd country array as value
        for letter in self.indexCharacters {
            self.indexCountryDict[letter] = self.getFilteredArray(startChar: letter)
        }
    }

    @objc func cancelBtnClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCountryByName(name: String) -> OPGCountry {
        let opgCountry: OPGCountry = OPGCountry()
        if self.countryArray.count > 0 {
            for country in self.countryArray {
                if country.name == name {
                    return country
                }
            }
        }
        return opgCountry
    }
    

    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if countryArray.count > 0 {
            return indexCharacters.count
        }
        else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let sectionTitle = self.indexCharacters[section]
        if self.indexCountryDict[sectionTitle] != nil {
            let sectionAnimals = self.indexCountryDict[sectionTitle]
            return (sectionAnimals?.count)!
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if countryArray.count > 0 {
            let sectionTitle = self.indexCharacters[indexPath.section]
            let sectionCountries = self.indexCountryDict[sectionTitle]
            let countryName = sectionCountries?[indexPath.row]
            cell.textLabel?.text = countryName as! String?
        }
        else {
            cell.textLabel?.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = self.indexCharacters[indexPath.section]
            let sectionCountries = self.indexCountryDict[sectionTitle]
            let countryName: String = sectionCountries?[indexPath.row] as! String

        // call this method on whichever class implements our delegate protocol
        delegate?.userDidChangeCountry(newCountry: self.getCountryByName(name: countryName))
        self.dismiss(animated: true, completion: nil)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexCharacters
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.indexCharacters[section]
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
       return self.indexCharacters.index(of: title)!
    }

}
