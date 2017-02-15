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
    
    func save() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        refresh()
        
        UserService.shared.get()?.canUpload = true
        UserService.shared.save()
        NotificationCenter.default.post(name: NSNotification.Name("CanUploadTrue"), object: nil)
    }
    
    func insert() {
        shouldRefresh = true
        save()
    }
    
    func delete(object: AlarmClock) {
        context.delete(object)
        save()
    }
    
    func upload() {
        let code = UserService.shared.get()!.code!
        let partnerCode = UserService.shared.get()!.partnerCode!
        let codePair = code < partnerCode ? code+"-"+partnerCode : partnerCode+"-"+code
        
        var data: [String: Any] = [String: Any]()
        for item in alarmClocks {
            let id = FIRDatabase.database().reference().childByAutoId().key
            data[id] = [
                "time": item.time,
                "period": item.period,
                "tag": item.tag,
                "isActive": item.isActive,
                "daysStr": item.daysStr,
                "timeZone": item.timeZone
            ]
        }
        let updates: [String : Any] = [
            "/alarms/"+codePair: data,
            "/canDownload/"+UserService.shared.get()!.partnerCode!: true
        ]
        FIRDatabase.database().reference().updateChildValues(updates) { (error, ref) in
            if error == nil {
                UserService.shared.get()?.canUpload = false
                UserService.shared.save()
                
                // Pop up alert: Upload Success
            } else {
                // Pop up alert: upload fail
            }
        }
    }
    
    func download() {
        let code = UserService.shared.get()!.code!
        let partnerCode = UserService.shared.get()!.partnerCode!
        let codePair = code < partnerCode ? code+"-"+partnerCode : partnerCode+"-"+code
        
        FIRDatabase.database().reference().child("alarms").child(codePair)
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
                            self.save()
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("DownloadedAlarmClocks"), object: nil)
                    UserService.shared.get()?.canUpload = false
                    UserService.shared.save()
                    NotificationCenter.default.post(name: NSNotification.Name("CanUploadFalse"), object: nil)
                } catch {
                    // Delete Data Fail
                }
            })
    }
}
