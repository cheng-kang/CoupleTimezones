//
//  ConstantService.swift
//  CoupleTimezones
//
//  Created by Ant on 23/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation

class ConstantService: NSObject {
    static let shared = ConstantService()
    
    override init() {
        super.init()
        
        var tz = [String]()
        tz.append(contentsOf: NSTimeZone.knownTimeZoneNames)
        for i in 0..<priorityTimeZones.count {
            tz.remove(at: tz.index(of: priorityTimeZones[i])!)
        }
        for i in 0..<priorityTimeZones.count {
            tz.insert(priorityTimeZones[i], at: i)
        }
        self.timeZones =  tz
        
        
        var tzn = [String]()
        for i in 0..<timeZones.count {
            tzn.append(TimeZone(identifier: timeZones[i])!.localizedName(for: .shortGeneric, locale: Locale.current)!)
        }
        self.timeZoneNames = tzn
    }
    
    var supportedCountriesNames: [String] = [
        NSLocalizedString("China", comment: "中国"),
        NSLocalizedString("United States", comment: "美国"),
        NSLocalizedString("United Kingdom", comment: "英国"),
        NSLocalizedString("Japan", comment: "日本"),
        NSLocalizedString("South Korea", comment: "韩国"),
        NSLocalizedString("Singapore", comment: "新加坡"),
        NSLocalizedString("Frence", comment: "法国"),
        NSLocalizedString("Canada", comment: "加拿大"),
        NSLocalizedString("Australia", comment: "澳大利亚"),
        NSLocalizedString("Germany", comment: "德国"),
        NSLocalizedString("Italy", comment: "意大利"),
        NSLocalizedString("Switzerland", comment: "瑞士"),
    ]
    var supportedCountriesCodes: [String] = [
        "CN",
        "US",
        "UK",
        "JP",
        "KP",
        "SG",
        "FR",
        "CA",
        "AU",
        "DE",
        "IT",
        "CH"
    ]
    func supportedContriesIndex(of countryCode: String?) -> Int {
        if let code = countryCode {
            if let idx = supportedCountriesCodes.index(of: code) {
                return idx
            }
        }
        return 0
    }
    var priorityTimeZones = [
        "Asia/Shanghai",
        "America/Los_Angeles",
        "Europe/London",
        "Asia/Singapore",
        "Asia/Tokyo",
        "Asia/Seoul",
        "Europe/Berlin",
        "Europe/Paris",
        "Europe/Zurich",
        "Europe/Rome",
        "Pacific/Easter",
        "Australia/Sydney",
        ]
    
    var priorityTimeZoneNames: [String] {
        var tzn = [String]()
        for i in 0..<priorityTimeZones.count {
            tzn.append(TimeZone(identifier: priorityTimeZones[i])!.localizedName(for: .shortGeneric, locale: Locale.current)!)
        }
        
        return tzn
    }
    
    func priorityIndex(of timeZone: String?) -> Int {
        if let name = timeZone {
            if let idx = priorityTimeZones.index(of: name) {
                return idx
            }
        }
        return 0
    }
    
    var timeZones: [String]!
    
    func index(of timeZone: String?) -> Int {
        if let name = timeZone {
            if let idx = timeZones.index(of: name) {
                return idx
            }
        }
        return 0
    }
    
    var timeZoneNames: [String]!
}
