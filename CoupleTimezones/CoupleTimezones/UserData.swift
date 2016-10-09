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
    
    // MARK: Alarm Clock Data
    var alarmClockList: [AlarmClockModel]?
    var isAlarmClockListUpdated = false
    
    func getAlarmClock() -> [AlarmClockModel] {
        if self.alarmClockList == nil || self.isAlarmClockListUpdated {
            if let data = UserDefaults.standard.object(forKey: "AlarmClock") {
                isAlarmClockListUpdated = false
                
                let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [AlarmClockModel]
                
                self.alarmClockList =  unArchivedData
            } else {
                self.alarmClockList = []
            }
        }
        
        
        return self.alarmClockList!
    }
    
    func updateAlarmClock(withList alarmClockList: [AlarmClockModel]) -> Bool {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: alarmClockList)
        UserDefaults.standard.set(encodedData, forKey: "AlarmClock")
        if UserDefaults.standard.synchronize() {
            self.isAlarmClockListUpdated = true
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
    
    // MARK: Settings Data
    var userSettings: UserSettings?
    var isUserSettingsUpdated = false
    var isUserSettingCompleted: Bool {
        return getUserSettings().partnerTimezone != nil
    }
    
    func getUserSettings() -> UserSettings {
        if self.userSettings == nil || self.isUserSettingsUpdated {
            if let data = UserDefaults.standard.object(forKey: "UserSettings") {
                self.isUserSettingsUpdated = false
                
                let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! UserSettings
                
                self.userSettings =  unArchivedData
            } else {
                self.userSettings = UserSettings()
            }
        }
        
        return self.userSettings!
    }
    
    func updateUserSettings(withUserSettings userSettings: UserSettings) -> Bool {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userSettings)
        UserDefaults.standard.set(encodedData, forKey: "UserSettings")
        if UserDefaults.standard.synchronize() {
            self.isUserSettingsUpdated = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataSynchronized"), object: nil)
            return true
        } else {
            return false
        }
    }
    
}
