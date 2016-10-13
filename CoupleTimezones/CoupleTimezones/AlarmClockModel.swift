//
//  AlarmClockModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class AlarmClockModel: NSObject, NSCoding {
    var _id: String?
    var id: String?
    var period: String? // at partnerTimezone
    var time: String? // at partnerTimezone
    var isSetBySelf: Bool? // if set by self, the time is in partner's time zone
    var tag: String?
    var isActive: Bool?
    var days: [Bool]?
    
    var soundIndex: Int? = 0
    
    var firedate: Date?
    
    var selfTimeText: String {
        return NSLocalizedString("My Time", comment: "我的时间")
    }
    
    init(withId id: String?, _id: String? = nil, period: String?, time: String?, isSetBySelf: Bool?, tag: String?, isActive: Bool?, days: [Bool]?, soundIndex: Int? = nil) {
        self._id = _id == nil ? UserData.sharedInstance.getUserSettings().id! + "\(Int(Date().timeIntervalSince1970))" : _id
        self.id = id
        self.period = period
        self.time = time
        self.isSetBySelf = isSetBySelf
        self.tag = tag
        self.isActive = isActive
        self.days = days
        self.soundIndex = soundIndex
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObject(forKey: "_id") as? String
        let id = aDecoder.decodeObject(forKey: "id") as? String
        let period = aDecoder.decodeObject(forKey: "period") as? String
        let time = aDecoder.decodeObject(forKey: "time") as? String
        let isSetBySelf = aDecoder.decodeObject(forKey: "isSetBySelf") as? Bool
        let tag = aDecoder.decodeObject(forKey: "tag") as? String
        let isActive = aDecoder.decodeObject(forKey: "isActive") as? Bool
        let days = aDecoder.decodeObject(forKey: "days") as? [Bool]
        let soundIndex = aDecoder.decodeObject(forKey: "soundIndex") as? Int
        
        self.init(withId: id, _id: _id, period: period, time: time, isSetBySelf: isSetBySelf, tag: tag, isActive: isActive, days: days, soundIndex: soundIndex)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(period, forKey: "period")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(isSetBySelf, forKey: "isSetBySelf")
        aCoder.encode(tag, forKey: "tag")
        aCoder.encode(isActive, forKey: "isActive")
        aCoder.encode(days, forKey: "days")
        aCoder.encode(soundIndex, forKey: "soundIndex")
    }
    
}
