//
//  Extensions.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation
import UIKit

// Hex Color Convenience Function
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, withAlpha alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension String {
    
    func widthThatFitsContentByHeight(_ height: CGFloat) -> CGFloat {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = self
        lbl.font = UIFont(name: "FZYanSongS-R-GB", size: 20)
        let newSize = lbl.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height))
        
        return newSize.width
    }
}

extension Date {
    func currentTimeAndPeriod(_ byTimezone: Int) {
        
    }
}

extension User {
    var relationShipLengthText: String {
        let df = DateFormatter()
        df.defaultDate = Date()
        df.dateFormat = "yyyy-MM-dd"
        if let date = df.date(from: self.startDate ?? "") {
            let today = Date()
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date, to: today)
            let (year, month, day) = (components.year!, components.month!, components.day!)
            var text = ""
            if year != 0 {
                text += year > 1 ? "\(year) "+NSLocalizedString("years ", comment: "年 ") : "\(year) "+NSLocalizedString("year ", comment: "年 ")
            }
            
            if month != 0 {
                text += month > 1 ? "\(month) "+NSLocalizedString("months", comment: "个月") : "\(month) "+NSLocalizedString("month", comment: "个月")
            }
            text += day > 1 ? " \(day) "+NSLocalizedString("days", comment: "天") : " \(day) "+NSLocalizedString("day", comment: "天")
            
            return text
        }
        return ""
    }
}

extension AlarmClock {
    var days: [Bool] {
        get {
            return self.daysStr!.components(separatedBy: "-").map({ (day) -> Bool in
                if day == "1" {
                    return true
                }
                return false
            })
        }
        set {
            self.daysStr = newValue.map { (day) -> String in
                if day == true {
                    return "1"
                }
                return "0"
            }.joined(separator: "-")
        }
    }
}
