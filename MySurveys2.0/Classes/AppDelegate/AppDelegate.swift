//
//  AppDelegate.swift
//  MySurveys2.0
//
//  Created by Chinthan on 08/06/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    internal var shouldRotate = false

    func setAppViews() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let logInViewController: LoginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        let tabBarController: TabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        var userLoggedIn: String? = UserDefaults.standard.object(forKey: "isUserLoggedIN") as? String
        if userLoggedIn==nil || (userLoggedIn?.isEmpty)! {
            let defaults = UserDefaults.standard
            defaults.set("0", forKey: "isUserLoggedIN")
            defaults.synchronize()
            userLoggedIn = UserDefaults.standard.object(forKey: "isUserLoggedIN") as? String
        }
        var controllers: Array<Any> = []
        if userLoggedIn == "1" {
            controllers = [logInViewController, tabBarController]
        }
        else {
            controllers = [logInViewController]
        }
        let navigationController = self.window?.rootViewController as! UINavigationController
        navigationController.viewControllers = controllers as! [UIViewController]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.setAppViews()
        OPGSDK.setAppVersion(OPGConstants.sdk.AppVersion)
        OPGSDK.initialize(withUserName: OPGConstants.sdk.Username, withSDKKey:OPGConstants.sdk.SharedKey)
        self.registerForPushNotifications(application: application)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {( granted, error) in
            if granted {
                 DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            else {
                // Do stuff if unsuccessful...
                print("User did not grant permission for notifications.")
            }
            })
        }
        else {
            // If user is not on iOS 10 use the old methods we've been using
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registeration failed \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Device Token:", tokenString)
        UserDefaults.standard.set(tokenString, forKey: "DeviceTokenID")
    }

    // for iOS 9 and below
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        if application.applicationState == UIApplicationState.active {
             DispatchQueue.global(qos: .default).sync {
                 CollabrateDB.sharedInstance().saveNotifications(userInfo as [AnyHashable: Any])
            }
        }
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1

        if #available(iOS 8.2, *) {
            print(notification.alertTitle!)
        }
    }


    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification
        print(notification.request.content.title)
        print(notification.request.content.userInfo)
        DispatchQueue.global(qos: .default).sync {
                 CollabrateDB.sharedInstance().saveNotifications(notification.request.content.userInfo as [AnyHashable: Any])
            }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification
        print(response.notification.request.content.userInfo)
        if response.notification.request.content.userInfo.count != 0 {
            DispatchQueue.global(qos: .default).sync {
                 CollabrateDB.sharedInstance().saveNotifications(response.notification.request.content.userInfo as [AnyHashable: Any])
            }
        }
    }

    // openUrl method for iOS 9 and above
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        var googleDidHandle: Bool = false
        var facebookDidHandle: Bool = false
        if #available(iOS 9.0, *) {
            googleDidHandle = GIDSignIn.sharedInstance().handle(url,
                                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }

        if #available(iOS 9.0, *) {
            facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!,
                                                                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return googleDidHandle || facebookDidHandle
    }


    // openUrl method for iOS 8
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if #available(iOS 9.0, *) {
            var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                                UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
    }
       let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)

        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
        return googleDidHandle || facebookDidHandle
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if shouldRotate {
                // only when inside the survey
                return UIInterfaceOrientationMask.all
            }
            else {
                // all other screens outside the survey
                return UIInterfaceOrientationMask.portrait
            }
        }
        else {
            return UIInterfaceOrientationMask.all      // for iPad
        }

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Generic Private Methods
    @available(iOS 10.0, *)
    func getUserinfoFromNotification(notification: UNNotification) -> [AnyHashable: Any] {
        let userinfo: [AnyHashable: Any] =  [
        AnyHashable("title"): notification.request.content.title,
        AnyHashable("body"): notification.request.content.body]
        return userinfo
    }



    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chinthu.MySurveys2_0" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MySurveys2_0", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
