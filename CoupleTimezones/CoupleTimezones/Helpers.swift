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
    
    func getDatetimeText(fromDate date: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getCTDate(atTimezone name: String) -> CTDateModel {
        
        let GMTDate = Date().addingTimeInterval(-TimeInterval(NSTimeZone.local.secondsFromGMT()))
        
        let dateAtTimezone = GMTDate.addingTimeInterval(TimeInterval(NSTimeZone(name: name)!.secondsFromGMT))
        
        return CTDateModel(withDate: dateAtTimezone)
    }
}
