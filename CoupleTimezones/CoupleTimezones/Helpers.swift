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
