//
//  TodayViewController.swift
//  RememberWidget1
//
//  Created by Ant on 21/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var table: UITableView!
    
    var selfNext: AlarmClock?
    var partnerNext: AlarmClock?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "localdata")
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
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selfNext = self.getSelfNextClock()
        partnerNext = self.getPartnerNextClock()
        
        // DateAndWeather cell & Settings cell
        var contentHeight = 90 + 30
        if selfNext != nil {
            contentHeight += 90
        }
        if partnerNext != nil {
            contentHeight += 90
        }
        if selfNext == nil && partnerNext == nil {
            contentHeight += 90
        }
        self.preferredContentSize = CGSize(width: 320, height: contentHeight)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    
    func getPartnerNextClock() -> AlarmClock? {
        if let currentUser = self.getCurrentUser() {
            // Fetch latest alarm clock for partner
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
            fetch.fetchLimit = 1
            
            let date = Date()
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(currentUser.partnerTimeZone!)
            let dateInPartnerTimeZone = date.addingTimeInterval(-timeInterval)
            let partnerTime = Helpers.sharedInstance.getDatetimeText(fromDate: dateInPartnerTimeZone, withFormat: "HH:mm")
            
            fetch.predicate = NSPredicate(format: "time >= %@ AND timeZone == %@",  partnerTime, currentUser.partnerTimeZone!)
            do {
                let fetchedData = try context.fetch(fetch) as! [AlarmClock]
                if fetchedData.count == 0 {
                    // If no later alarm clock today, fetch for the first alarm clock next day
                    let fetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
                    fetch2.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
                    fetch2.fetchLimit = 1
                    fetch2.predicate = NSPredicate(format: "timeZone == %@", currentUser.partnerTimeZone!)
                    
                    do {
                        let fetchedData2 = try context.fetch(fetch2) as! [AlarmClock]
                        if fetchedData2.count == 0 {
                            return nil
                        }
                        return fetchedData2[0]
                    } catch {
                        fatalError("getPartnerNextClock 2")
                    }
                }
                
                return fetchedData[0]
            } catch {
                fatalError("getPartnerNextClock 1")
            }
        } else {
            return nil
        }
    }
    
    func getSelfNextClock() -> AlarmClock? {
        if let currentUser = self.getCurrentUser() {
            // Fetch latest alarm clock for partner
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
            fetch.fetchLimit = 1
            
            let date = Date()
            fetch.predicate = NSPredicate(format: "time >= %@ AND timeZone == %@",  Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH:mm"), currentUser.timeZone!)
            do {
                let fetchedData = try context.fetch(fetch) as! [AlarmClock]
                if fetchedData.count == 0 {
                    // If no later alarm clock today, fetch for the first alarm clock next day
                    let fetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
                    fetch2.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
                    fetch2.fetchLimit = 1
                    fetch2.predicate = NSPredicate(format: "timeZone == %@", currentUser.timeZone!)
                    
                    do {
                        let fetchedData2 = try context.fetch(fetch2) as! [AlarmClock]
                        if fetchedData2.count == 0 {
                            return nil
                        }
                        return fetchedData2[0]
                    } catch {
                        fatalError("getSelfNextClock 2")
                    }
                }
                
                return fetchedData[0]
            } catch {
                fatalError("getSelfNextClock 1")
            }
        } else {
            return nil
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
    
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
