//
//  NotifService.swift
//  CoupleTimezones
//
//  Created by Ant on 16/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation
import UserNotifications

class NotifService: NSObject {
    static let shared = NotifService()
    
    func removeDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (dilivered) in
            let list = AlarmClockService.shared.get()
            
            for i in 0..<dilivered.count {
                let notification = dilivered[i]
                let request = notification.request
                
                for j in 0..<list.count {
                    if request.identifier == list[j].id {
                        if list[j].days == [false, false, false, false, false, false, false] {
                            list[j].isActive = false
                            AlarmClockService.shared.saveAndUploadSingle(list[j])
                        }
                    }
                }
                
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
        }
    }
    
    func scheduleLocalNotification(for alarmClock: AlarmClock) {
        let user = UserService.shared.get()!
        
        let isSetBySelf = alarmClock.timeZone == user.partnerTimeZone
        let title = !isSetBySelf ? "\(user.nickname!), "+NSLocalizedString("it's %@ now", comment: "现在 %@") : NSLocalizedString("it's %@ now", comment: "现在 %@")
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: [alarmClock.time!])
        content.body = NSString.localizedUserNotificationString(forKey: "\(alarmClock.tag!)",arguments: nil)
        content.sound = UNNotificationSound(named: "How_Long_Will_I_Love_You.aiff")
        
        
        var dateAtTimeInLocalTimeZone: Date!
        if isSetBySelf {
            let dateAtTimeInPartnerTimeZone = Helpers.sharedInstance.getDateTodayAtTime(alarmClock.time!, inFormat: "HH:mm")
            
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(user.partnerTimeZone!)
            
            dateAtTimeInLocalTimeZone = dateAtTimeInPartnerTimeZone.addingTimeInterval(timeInterval)
        } else {
            dateAtTimeInLocalTimeZone = Helpers.sharedInstance.getDateTodayAtTime(alarmClock.time!, inFormat: "HH:mm")
        }
        
        let hour = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "HH")
        let minute = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "mm")
        
        let isRepeat = alarmClock.daysStr != "0-0-0-0-0-0-0"
        
        // Remove notifications
        cancelLocalNotification(for: alarmClock.id!)
        //Reset notifications
        if alarmClock.isActive {
            if isRepeat {
                for i in 0...6 {
                    if alarmClock.days[i] {
                        content.userInfo = ["id": "\(alarmClock.id!)-\(i)", "sound": "How_Long_Will_I_Love_You"]
                        
                        var dateInfo = DateComponents()
                        dateInfo.weekday = i == 6 ? 1 : i+1
                        dateInfo.hour = Int(hour)
                        dateInfo.minute = Int(minute)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                        
                        // Create the request object.
                        let request = UNNotificationRequest(identifier: "\(alarmClock.id!)-\(i)", content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request) { (error) in
                            if error != nil {
                                Helpers.sharedInstance.toast(withString: "Please enable Local Notification!")
                                return
                            }
                            
                            Helpers.sharedInstance.toast(withString: "Good!")
                        }
                    }
                }
            } else {
                content.userInfo = ["id": alarmClock.id, "sound": "How_Long_Will_I_Love_You"]
                
                var dateInfo = DateComponents()
                dateInfo.hour = Int(hour)
                dateInfo.minute = Int(minute)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                
                // Create the request object.
                let request = UNNotificationRequest(identifier: alarmClock.id!, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        Helpers.sharedInstance.toast(withString: "Please enable Local Notification!")
                        return
                    }
                    
                    Helpers.sharedInstance.toast(withString: "Good!")
                }
            }
        }
    }
    
    func cancelLocalNotification(for identifier: String) {
        var identifiers = [identifier]
        for i in 0...6 {
            identifiers.append(identifier+"-\(i)")
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        
        Helpers.sharedInstance.toast(withString: identifier+" Local Notification Canceled!")
    }
}
