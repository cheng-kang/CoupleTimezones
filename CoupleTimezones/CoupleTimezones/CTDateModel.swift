//
//  CTDateModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/9.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class CTDateModel: NSObject {
    var date: Date!
    
    var time: String {
        return Helpers.sharedInstance.getDatetimeText(fromDate: self.date, withFormat: "HH:mm")
    }
    
    var timeWithoutColon: String {
        return Helpers.sharedInstance.getDatetimeText(fromDate: self.date, withFormat: "HH mm")
    }
    
    var period: String {
        return Helpers.sharedInstance.getDatetimeText(fromDate: self.date, withFormat: "a")
    }
    
    var dayDiffFromLocal: String {
        let localDay = Helpers.sharedInstance.getDatetimeText(fromDate: Date(), withFormat: "d")
        let thisDay = Helpers.sharedInstance.getDatetimeText(fromDate: self.date, withFormat: "d")
        
        return "\(Int(thisDay)! - Int(localDay)!)"
    }
    
    init(withDate date: Date) {
        super.init()
        self.date = date
    }
}
