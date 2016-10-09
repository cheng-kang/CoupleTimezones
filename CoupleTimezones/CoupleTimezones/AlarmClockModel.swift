//
//  AlarmClockModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class AlarmClockModel: NSObject, NSCoding {
    var id: String!
    var period: String!
    var time: String!
    var isSetBySelf: Bool!
    var content: String!
    var isActive: Bool!
    var days: [Bool]!
    
    var selfTimeText: String {
        return NSLocalizedString("My Time", comment: "我的时间")
    }
    
    init(withId id: String, period: String, time: String, isSetBySelf: Bool, content: String, isActive: Bool, days: [Bool]) {
        self.id = id
        self.period = period
        self.time = time
        self.isSetBySelf = isSetBySelf
        self.content = content
        self.isActive = isActive
        self.days = days
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let period = aDecoder.decodeObject(forKey: "period") as! String
        let time = aDecoder.decodeObject(forKey: "time") as! String
        let isSetBySelf = aDecoder.decodeObject(forKey: "isSetBySelf") as! Bool
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let isActive = aDecoder.decodeObject(forKey: "isActive") as! Bool
        let days = aDecoder.decodeObject(forKey: "days") as! [Bool]
        
        self.init(withId: id, period: period, time: time, isSetBySelf: isSetBySelf, content: content, isActive: isActive, days: days)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(period, forKey: "period")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(isSetBySelf, forKey: "isSetBySelf")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(isActive, forKey: "isActive")
        aCoder.encode(days, forKey: "days")
    }
    
}
