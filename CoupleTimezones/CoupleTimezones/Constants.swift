//
//  Global.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation
import UIKit

let BG = UIColor(red: 252, green: 252, blue: 252)
let TEXT_LIGHT = UIColor(red: 252, green: 252, blue: 252)
let TEXT_LIGHT_HIGHLIGHTED = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7)
let TEXT_GREY = UIColor(red: 240, green: 239, blue: 241)
let TEXT_DARK = UIColor(red: 51, green: 48, blue: 59)
let SLIDER_BLOCK = UIColor(red: 68, green: 64, blue: 78)
let SLIDER_BG_LIGHT = UIColor(red: 240, green: 239, blue: 241)
let SLIDER_BG_DARK = UIColor(red: 93, green: 87, blue: 107)
let RATIO_BLOCK = UIColor(red: 68, green: 64, blue: 78)
let RATIO_BG_LIGHT = UIColor(red: 240, green: 239, blue: 241)
let RATIO_BG_DARK = UIColor(red: 93, green: 87, blue: 107)
let DAY_SQUARE_LIGHT = UIColor(red: 196, green: 193, blue: 201)
let DAY_SQUARE_DARK = UIColor(red: 93, green: 87, blue: 107)

func TEXT_FONT(withSize size: CGFloat) -> UIFont {
    return UIFont(name: "FZYanSongS-R-GB", size: size)!
}

var AVAILABLE_TIME_ZONE_LIST: [String] {
    let currentSupportList = ["America/Los_Angeles", "Europe/London", "Asia/Shanghai"]
    
    let localTimeZoneName = TimeZone.current.identifier
    if let _ = currentSupportList.index(of: localTimeZoneName) {
        return currentSupportList
    } else {
        var newList = [String]()
        newList.append(localTimeZoneName)
        newList.append(contentsOf: currentSupportList)
        return newList
    }
}

var AVAILABLE_TIME_ZONE_LIST_LOCALIZED: [String] {
    let originalList = AVAILABLE_TIME_ZONE_LIST
    var localizedList = [String]()
    
    for name in originalList {
        localizedList.append(TimeZone(identifier: name)!.localizedName(for: .shortGeneric, locale: Locale.current)!)
    }
    
    return localizedList
}

let timezones = TimeZone.knownTimeZoneIdentifiers
