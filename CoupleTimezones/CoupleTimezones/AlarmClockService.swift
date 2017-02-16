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
    fileprivate var shouldRefresh: Bool = false
    
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
            
            shouldRefresh = false
            
            return self.alarmClocks
        } catch {
            fatalError("Can't fetch user data.")
        }
    }
    
    func new() -> AlarmClock {
        return AlarmClock(context: context)
    }
    
    func save(_ canUpload: Bool = true) {
        shouldRefresh = true
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        refresh()
        
        if canUpload {
            UserService.shared.get()?.canUpload = true
            UserService.shared.save()
            NotificationCenter.default.post(name: NSNotification.Name("CanUploadTrue"), object: nil)
        }
    }
    
    func saveAndUploadSingle(_ object: AlarmClock) {
        shouldRefresh = true
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
        FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
            if error == nil {
                self.save()
                NotifService.shared.scheduleLocalNotification(for: object)
                UserService.shared.get()?.canUpload = false
                UserService.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
                
                // Pop up alert: Upload Success
            } else {
                // Pop up alert: upload fail
            }
        })
    }
    
    func insert() {
        shouldRefresh = true
        save()
    }
    
    func delete(_ object: AlarmClock) {
        context.delete(object)
        shouldRefresh = true
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
        FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
            if error == nil {
                self.delete(object)
                UserService.shared.get()?.canUpload = false
                UserService.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                // Pop up alert: Upload Success
                NotifService.shared.cancelLocalNotification(for: key)
            } else {
                // Pop up alert: upload fail
            }
        })
    }
    
    func upload() {
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
                UserService.shared.get()?.canUpload = false
                UserService.shared.save()
                NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("ActivityDone"), object: nil)
                // Pop up alert: Upload Success
            } else {
                // Pop up alert: upload fail
            }
        }
    }
    
    func download() {
        NotificationCenter.default.post(name: NSNotification.Name("ActivityStart"), object: nil)
        FIRDatabase.database().reference().child("alarms").child(pairCode)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                NotificationCenter.default.post(name: NSNotification.Name("DownloadingAlarmClocks"), object: nil)
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AlarmClock")
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                do {
                    try self.context.execute(request)
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
                            self.save(false)
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("DownloadedAlarmClocks"), object: nil)
                    UserService.shared.get()?.canUpload = false
                    UserService.shared.save()
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
                } catch {
                    // Delete Data Fail
                }
            })
    }
}
