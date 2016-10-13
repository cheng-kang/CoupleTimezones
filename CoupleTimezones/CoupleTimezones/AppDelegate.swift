//
//  AppDelegate.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
//        UserDefaults.standard.removeObject(forKey: "AlarmClock")
//        UserDefaults.standard.removeObject(forKey: "UserSettings")
//        UserDefaults.standard.synchronize()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (isSuccess, error) in
            if error != nil {
                Helpers.sharedInstance.toast(withString: "Error!")
                return
            }
            
            if isSuccess {
                Helpers.sharedInstance.toast(withString: "Local Notification Enabled!")
            } else {
                Helpers.sharedInstance.toast(withString: "Please Enable Local Notification In Settings.")
            }
        }
        Helpers.sharedInstance.checkDeliveredLocalNotification()
        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Play sound
        
        let alert = UIAlertController(title: NSLocalizedString("Remember", comment: "记得"), message: notification.request.content.body, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "知道了"), style: .cancel, handler: nil)
        
        alert.addAction(dismissAction)
        
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

