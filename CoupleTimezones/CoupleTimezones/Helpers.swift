//
//  Helpers.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Helpers: NSObject {
    static let sharedInstance = Helpers()
    
    func toast(withString text: String) {
        // toast with string
        print(text)
    }
    
    func getTimezoneIndexByIdentifier(_ identifier: String?) -> Int {
        
        if let name = identifier {
            if let timezoneIndex = AVAILABLE_TIME_ZONE_LIST.index(of: name) {
                return timezoneIndex
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TimeZoneNotSupported"), object: nil)
        return 0
    }
    
    func checkAlarmSchdule(_ alarmList: [AlarmClockModel], callback: @escaping (([AlarmClockModel])->())) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            
            for i in 0..<alarmList.count {
                let alarm = alarmList[i]
                var isScheduled = false
                for j in 0..<requests.count {
                    let request = requests[j]
                    if request.identifier == (alarm.isSetBySelf! ? alarm._id : alarm.id) {
                        isScheduled = true
                        break
                    }
                }
                
                if alarm.isActive! {
                    if isScheduled {
                        
                    } else {
                        
                    }
                } else {
                    if isScheduled {
                        
                    } else {
                        
                    }
                }
            }
            
            callback(alarmList)
        })
    }
    
    func dateComponentsFor(_ alarmClock: AlarmClockModel) {
        
    }
    
    func AddLocalNotification(_ identifier: String, tag: String, fireDate: DateComponents, musicIndex: Int? = nil, repeated: Bool) {
        let content = UNMutableNotificationContent()
        content.body = tag
        content.sound = UNNotificationSound(named: "CoupleTimezones/ElephanteCatchingOnfeat25")
        content.userInfo = ["id": identifier, "sound": "ElephanteCatchingOnfeat25"]
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: repeated)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                self.toast(withString: "Please enable Local Notification!")
                return
            }
            
            self.toast(withString: "Good!")
        }
    }
    
    func scheduleLocalNotification(_ alarmClock: AlarmClockModel, isNew: Bool = false) {
        let settings = UserData.sharedInstance.getUserSettings()
        
        var dateAtTimeInLocalTimeZone: Date!
        if alarmClock.isSetBySelf! {
            let dateAtTimeInPartnerTimeZone = self.getDateTodayAtTime(alarmClock.time!, inFormat: "HH:mm")
            
            let timeInterval = self.getTimeIntervalBetweenLocalAndTimeZone(settings.partnerTimezone!)
            
            dateAtTimeInLocalTimeZone = dateAtTimeInPartnerTimeZone.addingTimeInterval(timeInterval)
        } else {
            dateAtTimeInLocalTimeZone = Helpers.sharedInstance.getDateTodayAtTime(alarmClock.time!, inFormat: "HH:mm")
        }
        
        let hour = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "HH")
        let minute = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "mm")
        
        var fireDate = DateComponents()
        fireDate.hour = Int(hour)
        fireDate.minute = Int(minute)
        
        var isRepeated = false
        for i in 0..<alarmClock.days!.count {
            if !isNew {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmClock._id!+"-\(i)"])
            }
            if alarmClock.days![i] {
                isRepeated = true
                
                fireDate.weekdayOrdinal = i
                Helpers.sharedInstance.AddLocalNotification(alarmClock._id!+"-\(i)", tag: alarmClock.tag!, fireDate: fireDate, musicIndex: alarmClock.soundIndex, repeated: true)
            }
        }
        
        if !isRepeated {
            if !isNew {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmClock._id!])
            }
            Helpers.sharedInstance.AddLocalNotification(alarmClock._id!, tag: alarmClock.tag!, fireDate: fireDate, musicIndex: alarmClock.soundIndex, repeated: false)
            
            self.toast(withString: "Non-repeat Local Notification Reseted!")
        }
    }
    
    func cancelLocalNotification(_ identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-0"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-1"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-2"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-3"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-4"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-5"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier+"-6"])
        
        self.toast(withString: identifier+" Local Notification Canceled!")
    }
    
    func checkDeliveredLocalNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (dilivered) in
            let selfList = UserData.sharedInstance.getAlarmClock(ofSelf: true)
            let partnerList = UserData.sharedInstance.getAlarmClock(ofSelf: false)
            
            for i in 0..<dilivered.count {
                let notification = dilivered[i]
                let request = notification.request
                
                for j in 0..<selfList.count {
                    if request.identifier == selfList[j]._id {
                        if selfList[j].days! == [false, false, false, false, false, false, false] {
                            selfList[j].isActive = false
                        }
                    }
                }
                
                for j in 0..<partnerList.count {
                    if request.identifier == partnerList[j]._id {
                        if partnerList[j].days! == [false, false, false, false, false, false, false] {
                            partnerList[j].isActive = false
                        }
                    }
                }
                
                UserData.sharedInstance.updateAlarmClock(ofSelf: true, withList: selfList, isFromUploadAlarmClocks: false, callback: { (isSuccess) in
                    UserData.sharedInstance.updateAlarmClock(ofSelf: false, withList: partnerList, isFromUploadAlarmClocks: false, callback: { (isSuccess) in
                        // update succeed
                        
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    })
                })
            }
        }
    }
    
    // MARK: Methods to deal with date
    func getDatetimeText(fromDate date: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getDateInFormat(_ format: String, withDateString dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: dateString)!
    }
    
    // get a CTDateModel of a specific time at today
    func getCTDate(atTimezone name: String, withTimeString time: String) -> CTDateModel {
        let df = DateFormatter()
        df.defaultDate = Date()
        df.dateFormat = "HH:mm"
        let date = df.date(from: time)!
        
        let GMTDate = date.addingTimeInterval(-TimeInterval(NSTimeZone.local.secondsFromGMT()))
        
        let dateAtTimezone = GMTDate.addingTimeInterval(TimeInterval(NSTimeZone(name: name)!.secondsFromGMT))
        
        return CTDateModel(currentDate: dateAtTimezone, originalDate: date)
    }
    
    // start here
    func getDateTodayAtTime(_ time: String, inFormat format: String) -> Date {
        let df = DateFormatter()
        df.defaultDate = Date()
        df.dateFormat = "HH:mm"

        return df.date(from: time)!
    }
    
    func getTimeIntervalBetweenLocalAndTimeZone(_ timeZoneName: String) -> TimeInterval {
        let local = Double(TimeZone.current.secondsFromGMT())
        let theOther = Double(TimeZone(identifier: timeZoneName)!.secondsFromGMT())
        return local - theOther
    }
    
    func getDateAtTimezone(_ timezoneName: String) -> Date {
        let date = Date()
        
        let GMTDate = date.addingTimeInterval(-TimeInterval(TimeZone.current.secondsFromGMT()))
        
        let dateAtTimezone = GMTDate.addingTimeInterval(TimeInterval(TimeZone(identifier: timezoneName)!.secondsFromGMT()))
        
        return dateAtTimezone
    }
}
