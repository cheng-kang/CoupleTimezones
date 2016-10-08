//
//  UserSettings.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/8.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class UserSettings: NSObject, NSCoding {
    var nickname: String?
    var partnerNickname: String?
    var code: String?
    var partnerCode: String?
    var timezone: Int?
    var partnerTimezone: Int?
    
    
    override init() {
        super.init()
    }
    
    init(withNickname nickname: String?, partnerNickname: String?, code: String?, partnerCode: String?, timezone: Int?, partnerTimezone: Int?) {
        self.nickname = nickname
        self.partnerNickname = partnerNickname
        self.code = code
        self.partnerCode = partnerCode
        self.timezone = timezone
        self.partnerTimezone = partnerTimezone
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(withNickname: aDecoder.decodeObject(forKey: "nickname") as? String,
                  partnerNickname: aDecoder.decodeObject(forKey: "partnerNickname") as? String,
                  code: aDecoder.decodeObject(forKey: "code") as? String,
                  partnerCode: aDecoder.decodeObject(forKey: "partnerCode") as? String,
                  timezone: aDecoder.decodeObject(forKey: "timezone") as? Int,
                  partnerTimezone: aDecoder.decodeObject(forKey: "partnerTimezone") as? Int
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(partnerNickname, forKey: "partnerNickname")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(partnerCode, forKey: "partnerCode")
        aCoder.encode(timezone, forKey: "timezone")
        aCoder.encode(partnerTimezone, forKey: "partnerTimezone")
    }
}
