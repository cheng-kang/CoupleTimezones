//
//  AlarmClockService.swift
//  CoupleTimezones
//
//  Created by Ant on 13/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AlarmClockService: NSObject {
    static let shared = AlarmClockService()
    
    fileprivate var alarmClocks: [AlarmClock] = [AlarmClock]()
    fileprivate var shouldRefresh = false
    
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    var pairCode: String {
        let code = UserService.shared.get()!.code!
        let partnerCode = UserService.shared.get()!.partnerCode!
        
        return code < partnerCode ? code+"-"+partnerCode : partnerCode+"-"+code
    }
    
    func get() -> [AlarmClock] {
        if alarmClocks != [] && !shouldRefresh {
            return alarmClocks
        }
        
        return refresh()
    }
    
    @discardableResult
    func refresh() -> [AlarmClock] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
        fetch.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        do {
            let fetchedData = try context.fetch(fetch) as! [AlarmClock]
            if fetchedData.count == 0 {
                return []
            }
            
            self.alarmClocks = fetchedData
            self.shouldRefresh = false
            
            return self.alarmClocks
        } catch {
            fatalError("Can't fetch user data.")
        }
    }
    
    func new() -> AlarmClock {
        return AlarmClock(context: context)
    }
    
    func save() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        self.shouldRefresh = true
        
        // Tell AlarmClockViewController to refresh alarm clocks
        NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
    }
    
    func saveAndUploadSingle(_ object: AlarmClock) {
        NotificationCenter.default.post(name: NSNotification.Name("ActivityStart"), object: nil)
        
        let data: [String: Any] = [
            "time": object.time!,
            "period": object.period!,
            "tag": object.tag!,
            "isActive": object.isActive,
            "daysStr": object.daysStr!,
            "timeZone": object.timeZone!
        ]
        let key = object.id!
        let updates: [String : Any] = [
            "/alarms/\(pairCode)/\(key)": data,
            "/canDownload/"+UserService.shared.get()!.partnerCode!: true,
            "/canDownload/"+UserService.shared.get()!.code!: NSNull()
        ]
        
        // Check connection state
        if StateService.shared.isConnected && StateService.shared.isMatched {
            FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                if error == nil {
                    // Save change and schedual notification
                    self.save()
                    NotifService.shared.scheduleLocalNotification(for: object)
                    
                    // Dismiss loading view
                    NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                    
                    // Pop up alert: Upload Success
                } else {
                    // Pop up alert: upload fail
                }
            })
        } else {
            Helpers.sharedInstance.toast(withString: NSLocalizedString("Fail to connect to server. Please manually upload later.", comment: "无法连接到服务器。请稍后手动上传。"))
            
            // Save change and schedual notification
            self.save()
            NotifService.shared.scheduleLocalNotification(for: object)
            
            // Set canUpload to true
            // for later manual upload
            UserService.shared.setCanUpload()
            
            NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
        }
    }
    
    func insert() {
        save()
    }
    
    func delete(_ object: AlarmClock) {
        // Cancel notification
        NotifService.shared.cancelLocalNotification(for: object.id!)
        context.delete(object)
        save()
    }
    
    func deleteAndUploadSingle(_ object: AlarmClock) {
        let key = object.id!
        NotificationCenter.default.post(name: NSNotification.Name("ActivityStart"), object: nil)
        
        let updates: [String : Any] = [
            "/alarms/\(pairCode)/\(key)": NSNull(),
            "/canDownload/"+UserService.shared.get()!.partnerCode!: true,
            "/canDownload/"+UserService.shared.get()!.code!: NSNull()
        ]
        if StateService.shared.isConnected && StateService.shared.isMatched {
            FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                if error == nil {
                    self.delete(object)
                    
                    // Dismiss loading view
                    NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                    // Pop up alert: Upload Success
                } else {
                    // Pop up alert: upload fail
                }
            })
        } else {
            Helpers.sharedInstance.toast(withString: NSLocalizedString("Fail to connect to server. Please manually upload later.", comment: "无法连接到服务器。请稍后手动上传。"))
            
            // Save change
            self.delete(object)
            NotifService.shared.cancelLocalNotification(for: key)
            
            // Set canUpload to true
            // for later manual upload
            UserService.shared.setCanUpload()
            
            NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
        }
    }
    
    // Avalable only when connection is on and canUpload is true
    func upload() {
        if StateService.shared.isMatched {
            NotificationCenter.default.post(name: NSNotification.Name("ActivityStart"), object: nil)
            var data: [String: Any] = [String: Any]()
            for item in alarmClocks {
                data[item.id!] = [
                    "time": item.time,
                    "period": item.period,
                    "tag": item.tag,
                    "isActive": item.isActive,
                    "daysStr": item.daysStr,
                    "timeZone": item.timeZone
                ]
            }
            let updates: [String : Any] = [
                "/alarms/"+pairCode: data,
                "/canDownload/"+UserService.shared.get()!.partnerCode!: true,
                "/canDownload/"+UserService.shared.get()!.code!: NSNull()
            ]
            FIRDatabase.database().reference().updateChildValues(updates) { (error, ref) in
                if error == nil {
                    UserService.shared.setCanUpload(false)
                    NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                    // Pop up alert: Upload Success
                } else {
                    // Pop up alert: upload fail
                }
            }
        }
    }
    
    // Avalable only when connection is on and canUpload is true
    func download() {
        if StateService.shared.isMatched {
            NotificationCenter.default.post(name: NSNotification.Name("ActivityStart"), object: nil)
            FIRDatabase.database().reference().child("alarms").child(pairCode)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    let currentList = self.get()
                    for item in currentList {
                        self.delete(item)
                    }
                    if let data = snapshot.value as? [String : Any] {
                        for (key, value) in data {
                            let item = value as! [String: Any]
                            let alarm = self.new()
                            alarm.id = key
                            alarm.time = item["time"] as! String
                            alarm.period = item["period"] as! String
                            alarm.tag = item["tag"] as! String
                            alarm.isActive = item["isActive"] as! Bool
                            alarm.daysStr = item["daysStr"] as! String
                            alarm.timeZone = item["timeZone"] as! String
                            self.save()
                        }
                    } else {
                        self.shouldRefresh = true
                        // Tell AlarmClockViewController to refresh alarm clocks
                        NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
                    }
                    
                    UserService.shared.setCanUpload(false)
                    NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                    
                    
                    let updates: [String : Any] = [
                        "/canDownload/"+UserService.shared.get()!.code!: NSNull()
                    ]
                    
                    FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                            // Pop up alert: Upload Success
                        } else {
                            // Pop up alert: upload fail
                        }
                    })
                })
        }
    }
    
    func getPartnerNextClock() -> AlarmClock? {
        if let currentUser = UserService.shared.get() {
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
        if let currentUser = UserService.shared.get() {
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
}
