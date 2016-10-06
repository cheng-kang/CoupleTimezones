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
    var location: String!
    var content: String!
    var isActive: Bool!
    var days: [Bool]!
    
    init(withId id: String, period: String, time: String, location: String, content: String, isActive: Bool, days: [Bool]) {
        self.id = id
        self.period = period
        self.time = time
        self.location = location
        self.content = content
        self.isActive = isActive
        self.days = days
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let period = aDecoder.decodeObject(forKey: "period") as! String
        let time = aDecoder.decodeObject(forKey: "time") as! String
        let location = aDecoder.decodeObject(forKey: "location") as! String
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let isActive = aDecoder.decodeObject(forKey: "isActive") as! Bool
        let days = aDecoder.decodeObject(forKey: "days") as! [Bool]
        
        self.init(withId: id, period: period, time: time, location: location, content: content, isActive: isActive, days: days)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(period, forKey: "period")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(isActive, forKey: "isActive")
        aCoder.encode(days, forKey: "days")
    }
    
}
