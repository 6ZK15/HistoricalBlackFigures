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
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var databaseReference: DatabaseReference!
    var randomFigure = Int()
    var randomNumber = UInt32()
    var figures = [Int]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            Messaging.messaging().subscribe(toTopic: "HBF")
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
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
    
    func application(_ application: UIApplication, A deviceToken: Data) {
        if let token = InstanceID.instanceID().token() {
            print("InstanceID token: \(token)")
        }
    }

    func generateRandomNumber() {
        let reference = Database.database().reference()
        reference.observe(DataEventType.value) { (snapshot) in
            let childrenCount = snapshot.childrenCount - 4
            self.randomNumber = arc4random_uniform(UInt32(childrenCount))
        }
        self.checkUsedFigures()
    }
    
    func timestamp() {
        let reference = Database.database().reference()
        reference.observe(DataEventType.value) { (snapshot) in
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
        reference.observe(DataEventType.value) { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            let random = dict["_random"] as? UInt32
            self.randomNumber = random!
            UserDefaults.standard.set(self.randomNumber, forKey: "randomFigureIndex")
        }
    }
    
    
    func checkUsedFigures() {
        let reference = Database.database().reference()
        reference.child("_usedFigures").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snapshots {
                    let childSnapshot = snapshot.childSnapshot(forPath: child.key)
                    if let dbLocation = childSnapshot.value {
                        let dbIntLocation = dbLocation as! UInt32
                        if dbIntLocation == self.randomNumber {
                            reference.child("_usedFigures").child(child.key).removeValue()
                            self.generateRandomNumber()
                        }
                    }
                }
            }
            reference.child("_usedFigures").childByAutoId().setValue(self.randomNumber)
            UserDefaults.standard.set(self.randomNumber, forKey: "randomFigureIndex")
            reference.child("_random").setValue(self.randomNumber)
        }
    }
    
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
        print("Remote message app data: ", remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let reference = Database.database().reference()
        
        reference.child("_deviceToken").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for token in snapshots {
                    let tokenSnapshot = snapshot.childSnapshot(forPath: token.key)
                    if let deviceToken = tokenSnapshot.value {
                        let tokenString = deviceToken as! String
                        if tokenString == fcmToken {
                            reference.child("_deviceToken").child(token.key).removeValue()
                        }
                    }
                }
            }
            reference.child("_deviceToken").childByAutoId().setValue(fcmToken)
            UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification:
        UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
}
