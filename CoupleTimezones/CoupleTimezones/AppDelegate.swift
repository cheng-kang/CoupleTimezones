//
//  AppDelegate.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import AVFoundation
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Init Firebase
        FIRApp.configure()
        
        // Set up network connection service
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            let connected = snapshot.value as? Bool
            if  connected == true {
                StateService.shared.isConnected = true
            } else {
                StateService.shared.isConnected = false
            }
        })
        
        
        // Ask authorization of notification
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
        
        // Check for dilivered notification
        if UserService.shared.get() != nil {
            NotifService.shared.removeDeliveredNotifications()
        }
        
        // Init SlidingForm Color
        SlidingFormPageConfig.sharedInstance.bgColor = ThemeService.shared.page_element_dark
        SlidingFormPageConfig.sharedInstance.textColor = ThemeService.shared.text_light
        SlidingFormPageConfig.sharedInstance.textColorHighlighted = ThemeService.shared.text_light_highlighted
        SlidingFormPageConfig.sharedInstance.descColor = ThemeService.shared.text_grey_hightlighted
        SlidingFormPageConfig.sharedInstance.warningColor = ThemeService.shared.text_warning
        
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
        
        if UserService.shared.get() != nil {
            NotifService.shared.removeDeliveredNotifications()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        
        var player: AVAudioPlayer!
        let url = Bundle.main.url(forResource: notification.request.content.userInfo["sound"] as! String, withExtension: "aiff")
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
        
        let alert = AlertViewController.vc(title: NSLocalizedString("Remember", comment: "记得"), content: notification.request.content.body, dismissBtnTitle: NSLocalizedString("Dismiss", comment: "知道了"), dismissBtnClick: {
            if player.isPlaying {
                player.stop()
            }
            topWindow.isHidden = true
        })
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
        let list = AlarmClockService.shared.get()
        for item in list {
            if item.id == notification.request.identifier {
                // Do not upload this change
                // Because this alarm will be turned inactive on partner's device
                item.isActive = false
                AlarmClockService.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
            }
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        
        var player: AVAudioPlayer!
        let url = Bundle.main.url(forResource: notification.userInfo?["sound"] as! String, withExtension: "aiff")
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
        
        let alert = AlertViewController.vc(title: NSLocalizedString("Remember", comment: "记得"), content: notification.alertBody!, dismissBtnTitle: NSLocalizedString("Dismiss", comment: "知道了"), dismissBtnClick: {
            if player.isPlaying {
                player.stop()
            }
            topWindow.isHidden = true
        })
        
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: nil)

        let list = AlarmClockService.shared.get()
        for item in list {
            if item.id == notification.userInfo?["id"] as! String {
                // Do not upload this change
                // Because this alarm will be turned inactive on partner's device
                item.isActive = false
                AlarmClockService.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
            }
        }
    }

    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = PersistentContainer(name: "localdata")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

