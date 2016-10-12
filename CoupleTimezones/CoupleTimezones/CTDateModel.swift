//
//  CTDateModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/9.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

// CTDateModel
// !!!this currentDate may contain wrong day component
class CTDateModel: NSObject {
    var originalNickname: String?
    var originalTime: String?
    var originalTimezone: String?
    
    var originalDate: Date!
    
    var currentNickname: String?
    var currentTimezone: String?
    
    var currentDate: Date! {
        didSet {
            timeString = Helpers.sharedInstance.getDatetimeText(fromDate: currentDate, withFormat: "HH:mm")
            timeStringWithoutColon = Helpers.sharedInstance.getDatetimeText(fromDate: currentDate, withFormat: "HH mm")
            periodString = Helpers.sharedInstance.getDatetimeText(fromDate: currentDate, withFormat: "a")
        }
    }
    
    var timeIntervalBetweenTimezones: TimeInterval?
    
    var timeString: String!
    
    var timeStringWithoutColon: String!
    
    var periodString: String!
    
    var dayDiffString: String?
    
    func getDayDiffString() -> String {
        if let str = dayDiffString {
            return str
        } else {
            dayDiffString = ""
            return dayDiffString!
        }
    }
    
    init(currentDate: Date, originalDate: Date) {
        super.init()
        self.currentDate = currentDate
        self.originalDate = originalDate
    }
}
