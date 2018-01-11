//
//  AppDelegate.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/9/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseReference: FIRDatabaseReference!
    var randomFigure = Int()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        FIRApp.configure()
        timestamp()
        //let notification = UNMutableNotificationContent()
//        let hvc = HomeViewController()
//        notification.badge = hvc.badegeCount - 1 as NSNumber
        UIApplication.shared.applicationIconBadgeNumber = 0
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3130282757948775~1462148695")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func timestamp() {
        let reference = FIRDatabase.database().reference()
        reference.observe(FIRDataEventType.value) { (snapshot) in
                let dict = snapshot.value as! NSDictionary
                let timestamp = dict["_timeStamp"] as? String
                print(timestamp!)
                
                let date = NSDate();
                let formatter = DateFormatter();
                formatter.dateFormat = "MM-dd-yyyy"
                formatter.timeZone = NSTimeZone(abbreviation: "CST")! as TimeZone
                let defaultTimeZoneStr = formatter.string(from: date as Date)
                print(defaultTimeZoneStr)
                
                if timestamp != defaultTimeZoneStr {
                    let childrenCount = snapshot.childrenCount
                    let randomNumber = arc4random_uniform(UInt32(childrenCount))
                    reference.child("_random").setValue(randomNumber)
                    reference.child("_timeStamp").setValue(defaultTimeZoneStr)
                    print("Dates is not the same. Update Needed")
                    UserDefaults.standard.set(randomNumber, forKey: "randomFigureIndex")
                } else {
                    reference.child("_random").observe(FIRDataEventType.value, with: { (snapshot) in
                        self.randomFigure = snapshot.value as! Int
                        UserDefaults.standard.set(self.randomFigure, forKey: "randomFigureIndex")
                        print(UserDefaults.standard.set(self.randomFigure, forKey: "randomFigureIndex"))
                    })
                    print("Dates are identical. No need to update")
                }
            }
        }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

