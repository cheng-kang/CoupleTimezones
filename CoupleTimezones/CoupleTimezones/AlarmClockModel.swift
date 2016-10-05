//
//  AlarmClockModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class AlarmClockModel: NSObject {
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
}
