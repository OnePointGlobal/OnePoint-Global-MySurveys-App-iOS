//
//  NotificationsViewController.swift
//  MySurveys2.0
//
//  Created by Chinthan on 20/06/16.
//  Copyright © 2016 Chinthan. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class NotificationsViewController: RootViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate
{
    // MARK: - IBOutlets for View
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoNewNotifications : UILabel!
    
    // MARK: - Properties for viewcontroller
    var notificationArray : [NSDictionary] = []
    var selectedIndexArray : [Int] = []
    var isEditable : Bool = false
    var notificationDescription : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // thamarai changes
        let isOperating : Int? = UserDefaults.standard.value(forKey: "isOperating") as? Int
        let array : Array<Any>? = UserDefaults.standard.value(forKey: "downloadSurveysArray") as? Array<Any>
        if (isOperating == 2) && (array?.count == 0)
        {
            self.getNotificationsFromDB()
        }
        else
        {
            self.notificationArray.removeAll()                      //clear local notificationArray during refresh
            self.lblNoNewNotifications?.isHidden = false
            self.tableView.isUserInteractionEnabled = false                         //disable selection when there are no notifications.
            self.tableView.backgroundView = self.lblNoNewNotifications
            self.lblNoNewNotifications?.text = NSLocalizedString("No notifications so far.", comment: "No notifications so far.")
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
        }
        self.navigationController?.isNavigationBarHidden = false
        let btnEdit =  UIBarButtonItem(title: NSLocalizedString("Edit", comment: "") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(editNotificationTable))
        self.checkforAvailableNotifications()
        if self.notificationArray.count>0                                     //show edit button only if there are notifications.
        {
            self.tabBarController?.navigationItem.rightBarButtonItem = btnEdit
            self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
        }

        if self.isEditable == false
        {
            self.tabBarController?.navigationItem.rightBarButtonItem?.title=NSLocalizedString("Edit", comment: "")         //restore normal mode even when user changes screen and come back
            self.tabBarController?.navigationItem.leftBarButtonItem = nil
            self.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.isEditable = false
    }

    // MARK: - Generic Private Methods
    func deleteSelectedItems()
    {
        //Pressing delete without selecting any items, throw an alert.
        if self.selectedIndexArray.count == 0
        {
            super.showAlert(alertTitle: NSLocalizedString("MySurveys", comment: ""), alertMessage: NSLocalizedString("No items selected.", comment: ""), alertAction: NSLocalizedString("OK", comment: "OK"))
            self.tableView.reloadData()
            return
        }
        for selectedIndex in self.selectedIndexArray
        {
            let notifDict : NSDictionary = self.notificationArray[selectedIndex]
            let notifID : NSNumber = notifDict["AppNotificationID"] as! NSNumber
            DispatchQueue.global(qos: .default).sync {
                CollabrateDB.sharedInstance().deleteNotifications(notifID)
            }
        }
        self.getNotificationsFromDB()
        self.selectedIndexArray.removeAll()
        if (notificationArray.count==0)
        {
            self.checkforAvailableNotifications()               //set no notifications label in the center
        }
        self.tableView.reloadData()

    }

    func getNotificationsFromDB()
    {
        self.notificationArray = CollabrateDB.sharedInstance().loadNotifications() as! [NSDictionary]
        if (self.notificationArray.count)>0
        {
            for dict in self.notificationArray
            {
                if !self.notificationArray.contains(dict)
                {
                    self.notificationArray.append(dict)
                }
            }
        }
    }

    func checkforAvailableNotifications()
    {
        if self.notificationArray.count > 0
        {
            self.tableView.isUserInteractionEnabled = true
            self.lblNoNewNotifications?.isHidden = true
        } else {
            self.lblNoNewNotifications?.isHidden = false
            self.tableView.isUserInteractionEnabled = false                         //disable selection when there are no notifications.
            self.tableView.backgroundView = self.lblNoNewNotifications
            self.lblNoNewNotifications?.text = NSLocalizedString("No notifications so far.", comment: "No notifications so far.")
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
     // MARK: - IBAction methods
    func editNotificationTable(sender: UIBarButtonItem)
    {
        if self.isEditable
        {
            self.isEditable = false
            self.deleteSelectedItems()
            if self.notificationArray.count>0
            {
                self.tabBarController?.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Edit", comment: "")              //Toggle back to edit button title
                self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            else
            {
                self.tabBarController?.navigationItem.rightBarButtonItem?.title = nil                               //don't show edit button if there are no notifications
                self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false                         //should disable even if button is set to nil to avoid tap action triggering the IBAction method.
            }
            self.tabBarController?.navigationItem.leftBarButtonItem = nil                                     //remove cancel button
        }
        else
        {
            self.isEditable = true
            self.tabBarController?.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Delete", comment: "")                 //Toggle to delete button title
            let btnCancel =  UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelEditing))
            self.tabBarController?.navigationItem.leftBarButtonItem = btnCancel
            self.tableView.reloadData()                                                             //change notification table from reminder icon to select icon when edit btn is clicked
        }
    }
    
    func cancelEditing(sender: UIBarButtonItem)
    {
        self.tabBarController?.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Edit", comment: "")             //reset button from delete to Edit afetr clicking cancel
        self.tabBarController?.navigationItem.leftBarButtonItem = nil                                     //remove cancel button
        self.isEditable = false
        self.selectedIndexArray.removeAll()                                                 //clear selected items array after user cancels
        self.tableView.reloadData()                                                                             //reset table
    }

    
    // MARK: - Tableview Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80.0
        } else {
            return 60.0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tableViewCell : NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NotificationTableViewCell
        let dict : NSDictionary = notificationArray[indexPath.row] as NSDictionary
        let isRead : String = dict["IsRead"] as! String
        if isRead=="1"
        {
            let color : UIColor = UIColor(colorLiteralRed: 160/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1)     //for Hex A09E9E
            tableViewCell.lblNotificationDesc.textColor = color                          //change color if notification is read
        }
        else
        {
            let color : UIColor = UIColor(colorLiteralRed: 96/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1)     //for Hex 606060
            tableViewCell.lblNotificationDesc.textColor = color                          // color if notification is unread
        }
        tableViewCell.lblNotificationDesc.text = dict["Title"] as? String
        tableViewCell.layoutMargins = UIEdgeInsets.zero
        tableViewCell.accessoryType = .disclosureIndicator
        tableViewCell.selectionStyle = .none
        if self.isEditable
        {
            if ( UIDevice.current.userInterfaceIdiom == .phone )
            {
                tableViewCell.imgSelect.image = UIImage(named: "notif_deselect.png")                //deselect all cells on clicking cancel button
            }
            else
            {
                tableViewCell.imgSelect.image = UIImage(named: "notif_deselect_iPad.png")
            }
        }
        else
        {
            tableViewCell.contentView.backgroundColor = UIColor.clear
            tableViewCell.backgroundColor = UIColor.clear
            if ( UIDevice.current.userInterfaceIdiom == .phone )
            {
                tableViewCell.imgSelect.image = UIImage(named: "notif_reminder.png")
            }
            else
            {
                tableViewCell.imgSelect.image = UIImage(named: "notif_reminder_iPad.png")
            }
            
//            if (indexPath.row%2)==0                                                            //dummy condition to differentiate reminders and other notifs
//            {
//                tableViewCell.imgSelect.image = UIImage(named: "notif_reminder.png")
//            }
//            else
//            {
//                tableViewCell.imgSelect.image = UIImage(named: "notif_others.png")
//            }
        }
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell : NotificationTableViewCell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell

        if self.isEditable                                                                              //in edit mode, select the table view cells
        {
            if self.selectedIndexArray.contains(indexPath.row)
            {
                if ( UIDevice.current.userInterfaceIdiom == .phone )
                {
                    cell.imgSelect.image = UIImage(named: "notif_deselect.png")                             //deselect cell again after selecting
                }
                else
                {
                    cell.imgSelect.image = UIImage(named: "notif_deselect_iPad.png")
                }
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                let indexOfElelement = self.selectedIndexArray.index(of: indexPath.row)
                self.selectedIndexArray.remove(at: indexOfElelement!)                                       //provide index to remove an item
            }
            else
            {
                self.selectedIndexArray.append(indexPath.row)
                if ( UIDevice.current.userInterfaceIdiom == .phone )
                {
                    cell.imgSelect.image = UIImage(named: "notif_select.png")                   //select cell
                }
                else
                {
                    cell.imgSelect.image = UIImage(named: "notif_select_iPad.png")
                }
                
                let color : UIColor = UIColor(colorLiteralRed: 196/255.0, green: 196/255.0, blue: 196/255.0, alpha: 1)     //for Hex C4C4C4
                cell.contentView.backgroundColor = color
                cell.backgroundColor = color
            }
            
        }
        else
        {
            let dict : NSDictionary = notificationArray[indexPath.row] as NSDictionary
            CollabrateDB.sharedInstance().updateNotifications(dict["AppNotificationID"] as? NSNumber)            //update DB with notification ID as read.
            self.notificationDescription = dict["Body"] as? String
            self.performSegue(withIdentifier: "ShowNotification", sender: nil)                      //in normal mode, perform segue on selection
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            // handle delete (by removing the data from your array and updating the tableview)
            if (self.tableView) != nil
            {
                self.tableView.beginUpdates()
                let notifDict : NSDictionary = self.notificationArray[indexPath.row]            //Delete notification on swipe
                let notifID : NSNumber = notifDict["AppNotificationID"] as! NSNumber
                DispatchQueue.global(qos: .default).sync
                {
                    CollabrateDB.sharedInstance().deleteNotifications(notifID)
                }
                notificationArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                print("Deleted a row")
                self.tableView.endUpdates()
                if (notificationArray.count==0)
                {
                    self.checkforAvailableNotifications()               //set no notifications label in the center
                    self.tableView.reloadData()
                }
            }
        }
    }

    

    // MARK: - Segue Operation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "ShowNotification")
        {
            //pass data here
            let viewController : ShowNotificationViewController = segue.destination as! ShowNotificationViewController
            viewController.notificationDescription=self.notificationDescription
        }
        
    }


}
