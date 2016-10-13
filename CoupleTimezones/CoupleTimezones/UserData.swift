//
//  UserData.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserData: NSObject {
    static let sharedInstance = UserData()
    // MARK: Alarm Clock Data
    
    var selfAlarmList: [AlarmClockModel]?
    var partnerAlarmList: [AlarmClockModel]?
    var isSelfAlarmListUpdated = false
    var isPartnerAlarmListUpdated = false
    
    func getAlarmClock(ofSelf isSelf: Bool) -> [AlarmClockModel] {
        if isSelf {
            if self.selfAlarmList == nil || self.isSelfAlarmListUpdated {
                if let data = UserDefaults.standard.object(forKey: "SelfAlarmList") {
                    isSelfAlarmListUpdated = false
                    
                    let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [AlarmClockModel]
                    
                    self.selfAlarmList =  unArchivedData
                } else {
                    self.selfAlarmList = []
                }
            }
            return self.selfAlarmList!
        } else {
            if self.partnerAlarmList == nil || self.isPartnerAlarmListUpdated {
                if let data = UserDefaults.standard.object(forKey: "PartnerAlarmList") {
                    isPartnerAlarmListUpdated = false
                    
                    let unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [AlarmClockModel]
                    
                    self.partnerAlarmList =  unArchivedData
                } else {
                    self.partnerAlarmList = []
                }
            }
            return self.partnerAlarmList!
        }
    }
    
    func getAlarmClockAll() -> ([AlarmClockModel], Int) {
        var list = [AlarmClockModel]()
        let selfList = self.getAlarmClock(ofSelf: true)
        list.append(contentsOf: selfList)
        list.append(contentsOf: self.getAlarmClock(ofSelf: false))
        
        return (list, selfList.count)
    }
    
    func updateAlarmClock(ofSelf isSelf: Bool, withList alarmClockList: [AlarmClockModel], isFromUploadAlarmClocks: Bool = false, callback: ((_ isSuccess: Bool)->())? = nil) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: alarmClockList)
        UserDefaults.standard.set(encodedData, forKey: isSelf ? "SelfAlarmList" : "PartnerAlarmList")
        if UserDefaults.standard.synchronize() {
            let settings = self.getUserSettings()
            
            if isSelf {
                self.isSelfAlarmListUpdated = true
                settings.shouldUploadSelf = true
                if !isFromUploadAlarmClocks {
                    settings.partnerShouldUpdatePartner = true
                }
                self.updateUserSettings(withUserSettings: settings)
            } else {
                self.isPartnerAlarmListUpdated = true
                settings.shouldUploadPartner = true
                if !isFromUploadAlarmClocks {
                    settings.partnerShouldUpdateSelf = true
                }
                self.updateUserSettings(withUserSettings: settings)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: isSelf ? "SelfAlarmListSaved" : "PartnerAlarmListSaved"), object: nil)
            
            callback?(true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: (isSelf ? "Self" : "Partner")+"AlarmListSynchronizeFail"), object: nil)
            callback?(false)
        }
    }
    
    func updateAlarmClock(ofSelf isSelf: Bool, atIndex index: Int, withElement element: AlarmClockModel, isFromUploadAlarmClocks: Bool = false, callback: ((_ isSuccess: Bool)->())? = nil) {
        var curAlarmClockList = self.getAlarmClock(ofSelf: isSelf)
        curAlarmClockList[index] = element
        
        if element.isActive! == false {
            Helpers.sharedInstance.cancelLocalNotification(element._id!)
        } else {
            Helpers.sharedInstance.scheduleLocalNotification(element)
        }
        
        updateAlarmClock(ofSelf: isSelf, withList: curAlarmClockList, isFromUploadAlarmClocks: isFromUploadAlarmClocks, callback: callback)
    }
    
    func deleteAlarmClock(ofSelf isSelf: Bool, atIndex index: Int, callback: ((_ isSuccess: Bool)->())? = nil) {
        var curAlarmClockList = self.getAlarmClock(ofSelf: isSelf)
        Helpers.sharedInstance.cancelLocalNotification(curAlarmClockList[index]._id!)
        curAlarmClockList.remove(at: index)
        updateAlarmClock(ofSelf: isSelf, withList: curAlarmClockList, isFromUploadAlarmClocks: false, callback: callback)
    }
    
    func insertAlarmClock(toSelf isSelf: Bool, newElement: AlarmClockModel, callback: ((_ isSuccess: Bool)->())?) {
        var curAlarmClockList = self.getAlarmClock(ofSelf: isSelf)
        curAlarmClockList.append(newElement)
        
        updateAlarmClock(ofSelf: isSelf, withList: curAlarmClockList, callback: callback)
        
        Helpers.sharedInstance.scheduleLocalNotification(newElement)
    }
    
    func uploadAlarmClocks(ofSelf isSelf: Bool, withId id: String, callback: @escaping ((_ isSuccess: Bool)->())) {
        // if there is a match, the user can upload his/her(or partner's) data
        let db = FIRDatabase.database().reference().child("alarms").child(id)
        let alarmClocks = self.getAlarmClock(ofSelf: isSelf)
        for i in 0..<alarmClocks.count {
            let item = alarmClocks[i]
            if !item.isSetBySelf! {break} // don't upload partner's data
            
            if item.id == nil {
                let data = [
                    "tag": item.tag!,
                    "time": item.time!,
                    "period": item.period!,
                    "days": item.days!,
                    "isActive": item.isActive!
                    
                    ] as [String : Any]
                db.childByAutoId().setValue(data, withCompletionBlock: { (error, newAlarm) in
                    if error == nil {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: (isSelf ? "Self" : "Partner")+"AlarmListUploaded"), object: nil)
                        
                        item.id = newAlarm.key
                        
                        self.updateAlarmClock(ofSelf: isSelf, atIndex: i, withElement: item, isFromUploadAlarmClocks: true, callback: { isSuccess in
                            callback(isSuccess)
                        })
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: (isSelf ? "Self" : "Partner")+"AlarmListUploadFail"), object: nil)
                    }
                })
            } else {
                let data = [
                    "tag": item.tag!,
                    "time": item.time!,
                    "period": item.period!,
                    "days": item.days!,
                    "isActive": item.isActive!
                    
                    ] as [String : Any]
                db.child(item.id!).updateChildValues(data, withCompletionBlock: { (error, curAlarm) in
                    if error == nil {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: (isSelf ? "Self" : "Partner")+"AlarmListUploaded"), object: nil)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: (isSelf ? "Self" : "Partner")+"AlarmListUploadFail"), object: nil)
                    }
                })
            }
        }
    }
    
    func downloadAlarmClocks(ofSelf isSelf: Bool, withId id: String, callBack: @escaping (_ shouldUpdate: Bool)->()) {
        // if there is a match, the user can download his/her(or partner's) data
        (FIRDatabase.database().reference().child("alarms").child(id)).queryOrdered(byChild: "time").observe(.value, with: { (snapshot: FIRDataSnapshot) in
            if snapshot.exists() {
                let list = snapshot.value as! [String:Any]
                
                var alarmList = [AlarmClockModel]()
                for (key, value) in list {
                    let data = value as! [String:Any]
                    
                    let alarmClock = AlarmClockModel(withId: key,
                                                     period: data["period"] as! String,
                                                     time: data["period"] as! String,
                                                     isSetBySelf: isSelf,
                                                     tag: data["tag"] as! String,
                                                     isActive: data["isActive"] as! Bool,
                                                     days: data["days"] as! [Bool])
                    alarmList.append(alarmClock)
                }
                self.updateAlarmClock(ofSelf: isSelf, withList: alarmList, isFromUploadAlarmClocks: true, callback: { isSuccess in
                    callBack(isSuccess)
                })
            }
        })
        
    }
    
    func syncDataWithServer(callback: ((_ isSuccess: Bool)->())? = nil) {
        // 1). if shouldUpdateSelf, go to 2); if not, go to 3)
        // 2). download self, go to 5)
        // 3). if shouldUploadSelf, go to 4); if not, go to 5)
        // 4). upload self, go to 5)
        // 5). if shouldUpdatePartner, go to 6); if not, go to 7)
        // 6). download partner, go to 9)
        // 7). if shouldUploadPartner, go to 8), if not, go to 9)
        // 8). upload partner, go to 9)
        // 9). end
        checkMatch(successCallback: { (partnerId) in
            let settings = self.getUserSettings()
            if let id = self.getUserSettings().id {
                self.checkShouldUpdate(ofSelf: true, byId: id) { shouldUpdate in
                    if shouldUpdate {
                        self.downloadAlarmClocks(ofSelf: true, withId: settings.id!) { shouldUpdate in
                            self.changeShouldUpdate(itSelf: true, toNewValue: false, byId: settings.id!)
                            callback?(true)
                        }
                    } else {
                        if settings.partnerShouldUpdatePartner == true {
                            self.uploadAlarmClocks(ofSelf: true, withId: settings.id!, callback: { isSuccess in
                                if isSuccess {
                                    let curSettings = self.getUserSettings()
                                    curSettings.partnerShouldUpdatePartner = false
                                    self.updateUserSettings(withUserSettings: curSettings)
                                    // tell partner to update
                                    self.changeShouldUpdate(itSelf: false, toNewValue: true, byId: partnerId)
                                    
                                    callback?(true)
                                }
                            })
                        } else {
                            callback?(false)
                        }
                    }
                }
                
                self.checkShouldUpdate(ofSelf: false, byId: partnerId, callBack: { (shouldUpdate) in
                    if shouldUpdate {
                        self.downloadAlarmClocks(ofSelf: false, withId: partnerId) { shouldUpdate in
                            self.changeShouldUpdate(itSelf: false, toNewValue: false, byId: settings.id!)
                            callback?(true)
                        }
                    } else {
                        if settings.partnerShouldUpdateSelf == true {
                            self.uploadAlarmClocks(ofSelf: false, withId: partnerId, callback: { isSuccess in
                                if isSuccess {
                                    let curSettings = self.getUserSettings()
                                    curSettings.partnerShouldUpdateSelf = false
                                    self.updateUserSettings(withUserSettings: curSettings)
                                    // tell partner to update
                                    self.changeShouldUpdate(itSelf: true, toNewValue: true, byId: partnerId)
                                    
                                    callback?(true)
                                }
                            })
                        } else {
                            callback?(false)
                        }
                    }
                })
            }
        })
    }
    
    func checkMatch(successCallback: ((_ partnerId: String)->())?, failureCallback: (()->())? = nil) {
        (FIRDatabase.database().reference().child("users")).queryOrdered(byChild: "code").queryEqual(toValue: self.getUserSettings().partnerCode).observe(.value) { (snapshot: FIRDataSnapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                if let user = rest.value as? [String: String] {
                    if user["partnerCode"] == self.getUserSettings().code {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PartnerMatchFound"), object: nil)
                        successCallback?(rest.key)
                        return
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MatchPartnerNotFound"), object: nil)
            failureCallback?()
        }
    }
    
    func checkHasNew(byId id: String, successCallback: @escaping (_ hasNew: Bool)->()) {
        FIRDatabase.database().reference().child("hasNew").child(id).observe(.value) { (snapshot: FIRDataSnapshot) in
            if snapshot.exists() {
                let result = snapshot.value as! Bool
                successCallback(result)
            }
        }
    }
    
    func checkShouldUpdate(ofSelf isSelf: Bool, byId id: String, callBack: @escaping (_ shouldUpdate: Bool)->()) {
        FIRDatabase.database().reference().child(isSelf ? "shouldUpdateSelf" : "shouldUpdatePartner").child(id).observe(.value) { (snapshot: FIRDataSnapshot) in
            if snapshot.exists() {
                let result = snapshot.value as! Bool
                callBack(result)
            } else {
                callBack(false)
            }
        }
    }
    
    func changeShouldUpdate(itSelf: Bool, toNewValue newValue: Bool, byId id: String) {
        FIRDatabase.database().reference().child(itSelf ? "shouldUpdateSelf" : "shouldUpdatePartner").updateChildValues([id:newValue])
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
    
    func updateUserSettings(withUserSettings userSettings: UserSettings) {
        if let id = userSettings.id {
            let db = FIRDatabase.database().reference().child("users").child(id)
            
            let data = [
                "nickname": userSettings.nickname!,
                "code": userSettings.code!,
                "partnerCode": userSettings.partnerCode!
            ]
            
            db.updateChildValues(data, withCompletionBlock: { (error, curUser) in
                guard error == nil else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataUploadFail"), object: nil)
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataUploaded"), object: nil)
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: userSettings)
                UserDefaults.standard.set(encodedData, forKey: "UserSettings")
                if UserDefaults.standard.synchronize() {
                    self.isUserSettingsUpdated = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataSynchronized"), object: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataSynchronizFail"), object: nil)
                }
            })
        } else {
            let db = FIRDatabase.database().reference().child("users").childByAutoId()
            
            let data = [
                "nickname": userSettings.nickname!,
                "code": userSettings.code!,
                "partnerCode": userSettings.partnerCode!
            ]
            db.setValue(data, withCompletionBlock: { (error, newUser) in
                if error != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataUploadFail"), object: nil)
                    return
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataUploaded"), object: nil)
                    
                    userSettings.id = newUser.key
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: userSettings)
                    UserDefaults.standard.set(encodedData, forKey: "UserSettings")
                    if UserDefaults.standard.synchronize() {
                        self.isUserSettingsUpdated = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataSynchronized"), object: nil)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSettingDataSynchronizFail"), object: nil)
                    }
                }
            })
        }
        
    }
    
}
