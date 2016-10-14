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
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
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
