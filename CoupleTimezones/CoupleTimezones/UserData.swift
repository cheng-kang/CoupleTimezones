//
//  UserData.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class UserData: NSObject {
    static let sharedInstance = UserData()
    
    var alarmClickList: [AlarmClockModel]?
    var isUpdated = false
    
    // MARK: Alarm Clock Data
    func getAlarmClock() -> [AlarmClockModel] {
        
        
        if self.alarmClickList == nil || self.isUpdated {
            if let data = UserDefaults.standard.object(forKey: "AlarmClock") {
                isUpdated = false
                
                let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [AlarmClockModel]
                
                self.alarmClickList =  unArchivedData
            } else {
                self.alarmClickList = []
            }
        }
        
        
        return self.alarmClickList!
    }
    
    func updateAlarmClock(withList alarmClockList: [AlarmClockModel]) -> Bool {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: alarmClockList)
        UserDefaults.standard.set(encodedData, forKey: "AlarmClock")
        if UserDefaults.standard.synchronize() {
            self.isUpdated = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AlarmClockDataSynchronized"), object: nil)
            return true
        } else {
            return false
        }
    }
    
    func updateAlarmClock(atIndex index: Int, withElement element: AlarmClockModel) -> Bool {
        var curAlarmClockList = self.getAlarmClock()
        curAlarmClockList[index] = element
        
        return self.updateAlarmClock(withList: curAlarmClockList)
    }
    
    func insertAlarmClock(newElement: AlarmClockModel) -> Bool {
        var curAlarmClockList = self.getAlarmClock()
        curAlarmClockList.append(newElement)
        
        return self.updateAlarmClock(withList: curAlarmClockList)
    }
    
}
