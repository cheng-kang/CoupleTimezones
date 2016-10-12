//
//  Helpers.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation
import UIKit

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
    
    func AddLocalNotification(_ identifier: String, tag: String, fireDate: Date, musicIndex: Int? = nil) {
        
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
    func getDateOfTodayAtTime(_ time: String, inFormat format: String) -> Date {
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
