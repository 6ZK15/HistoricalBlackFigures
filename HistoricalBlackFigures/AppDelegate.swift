//
//  AppDelegate.swift
//  HistoricalBlackFigures
//
//  Created by Nehemiah Horace on 6/9/17.
//  Copyright © 2017 Nehemiah Horace. All rights reserved.
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
    var randomNumber = UInt32()
    var figures = [Int]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        FIRApp.configure()
        timestamp()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3130282757948775~1462148695")
        return true
    }

func applicationWillResignActive(_ application: UIApplication) {

// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should usethis method to pause the game.
}

func applicationDidEnterBackground(_ application: UIApplication) {
// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

func applicationWillEnterForeground(_ application: UIApplication) {
// Called as part of the transition from the background to the active state; here you can undo many of the changes madeon entering the background.
UIApplication.shared.applicationIconBadgeNumber = 0
}

func applicationDidBecomeActive(_ application: UIApplication) {
}

func applicationWillTerminate(_ application: UIApplication) {
}

    func generateRandomNumber() {
        let reference = FIRDatabase.database().reference()
        reference.observe(FIRDataEventType.value) { (snapshot) in
            let childrenCount = snapshot.childrenCount - 4
            self.randomNumber = arc4random_uniform(UInt32(childrenCount))
        }
        self.checkUsedFigures()
    }
    
    func timestamp() {
        let reference = FIRDatabase.database().reference()
        reference.observe(FIRDataEventType.value) { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            let timestamp = dict["_timeStamp"] as? String
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            formatter.timeZone = NSTimeZone(abbreviation: "CST")! as TimeZone
            let defaultTimeZoneStr = formatter.string(from: date as Date)
            print(defaultTimeZoneStr)
            if timestamp != defaultTimeZoneStr {
                reference.child("_timeStamp").setValue(defaultTimeZoneStr)
                self.generateRandomNumber()
            }
        }
    }
    
    func checkUsedFigures() {
        let reference = FIRDatabase.database().reference()
        reference.child("_usedFigures").observeSingleEvent(of: FIRDataEventType.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in snapshots {
                    let childSnapshot = snapshot.childSnapshot(forPath: child.key)
                    if let dbLocation = childSnapshot.value {
                        print(dbLocation as! UInt32)
                        let dbIntLocation = dbLocation as! UInt32
                        print("Int value", dbIntLocation)
                        if dbIntLocation == self.randomNumber {
                            print("true. Number is in Used Figures. Call another number")
                            reference.child("_usedFigures").child(child.key).removeValue()
                            self.generateRandomNumber()
                        } else {
                            print("false. Number is not in Used Figures")
                        }
                    }
                }
                
            }
            reference.child("_usedFigures").childByAutoId().setValue(self.randomNumber)
            print("false it does not exist in here")
            UserDefaults.standard.set(self.randomNumber, forKey: "randomFigureIndex")
            reference.child("_random").setValue(self.randomNumber)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
    }
}
