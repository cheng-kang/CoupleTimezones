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
    func cancelLocalNotification(_ identifier: String) {
    }
    
    func checkDeliveredLocalNotification() {
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
    
    // start here
    func getDateTodayAtTime(_ time: String, inFormat format: String = "HH:mm") -> Date {
        let df = DateFormatter()
        df.defaultDate = Date()
        df.dateFormat = format

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
