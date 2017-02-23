//
//  Helpers.swift
//  CoupleTimezones
//
//  Created by Ant on 22/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class WidgetHelpers: NSObject {
    static let shared = WidgetHelpers()
    
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
    
    var context: NSManagedObjectContext!{
        return self.persistentContainer.viewContext
    }
    
    func getPartnerNextClock() -> [AlarmClock] {
        if let currentUser = self.getCurrentUser() {
            // Fetch latest alarm clock for partner
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
//            fetch.fetchLimit = 1
            
            let date = Date()
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(currentUser.partnerTimeZone!)
            let dateInPartnerTimeZone = date.addingTimeInterval(-timeInterval)
            let partnerTime = Helpers.sharedInstance.getDatetimeText(fromDate: dateInPartnerTimeZone, withFormat: "HH:mm")
            
            fetch.predicate = NSPredicate(format: "time >= %@ AND timeZone == %@",  partnerTime, currentUser.partnerTimeZone!)
            do {
                let fetchedData = try context.fetch(fetch) as! [AlarmClock]
                
                return fetchedData
            } catch {
                fatalError("getPartnerNextClock 1")
            }
        } else {
            return []
        }
    }
    
    func getSelfNextClock() -> [AlarmClock] {
        if let currentUser = self.getCurrentUser() {
            // Fetch latest alarm clock for partner
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
//            fetch.fetchLimit = 1
            
            let date = Date()
            fetch.predicate = NSPredicate(format: "time >= %@ AND timeZone == %@",  self.getDatetimeText(fromDate: date, withFormat: "HH:mm"), currentUser.timeZone!)
            do {
                let fetchedData = try context.fetch(fetch) as! [AlarmClock]
                return fetchedData
            } catch {
                fatalError("getSelfNextClock 1")
            }
        } else {
            return []
        }
    }
    
    
    func getCurrentUser() -> User? {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        userFetch.fetchLimit = 1
        do {
            let fetchedUsers = try context.fetch(userFetch) as! [User]
            if fetchedUsers.count == 0 {
                return nil
            }
            
            return fetchedUsers[0]
        } catch {
            fatalError("Can't fetch user data.")
        }
    }
    
    func isCitySet() -> Bool {
        if let user = self.getCurrentUser() {
            if user.country == nil || user.country == "" {
                return false
            }
            return true
        }
        return false
    }
    
    
    
    func getDateAtTimezone(_ timezoneName: String) -> Date {
        let date = Date()
        
        let GMTDate = date.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
        
        let dateAtTimezone = GMTDate.addingTimeInterval(TimeInterval(TimeZone(identifier: timezoneName)!.secondsFromGMT()))
        
        return dateAtTimezone
    }
    
    // MARK: Methods to deal with date
    func getDatetimeText(fromDate date: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
