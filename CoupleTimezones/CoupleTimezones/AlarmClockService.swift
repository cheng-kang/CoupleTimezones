//
//  AlarmClockService.swift
//  CoupleTimezones
//
//  Created by Ant on 13/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import CoreData

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
    }
    
    func insert() {
        shouldRefresh = true
        save()
    }
    
    func delete(object: AlarmClock) {
        context.delete(object)
        save()
    }
}
