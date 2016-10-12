//
//  UserSettings.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/8.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class UserSettings: NSObject, NSCoding {
    var id: String?
    var nickname: String?
    var partnerNickname: String?
    var code: String?
    var partnerCode: String?
    var timezone: String?
    var partnerTimezone: String?
    
    var shouldUploadSelf: Bool? = true
    var shouldUploadPartner: Bool? = false
    var partnerShouldUpdateSelf: Bool? = false
    var partnerShouldUpdatePartner: Bool? = true
    
    override init() {
        super.init()
    }
    
    init(withId id: String?, nickname: String?, partnerNickname: String?, code: String?, partnerCode: String?, timezone: String?, partnerTimezone: String?, shouldUploadSelf: Bool? = true, shouldUploadPartner: Bool? = true, partnerShouldUpdateSelf: Bool? = true, partnerShouldUpdatePartner: Bool? = true) {
        self.id = id
        self.nickname = nickname
        self.partnerNickname = partnerNickname
        self.code = code
        self.partnerCode = partnerCode
        self.timezone = timezone
        self.partnerTimezone = partnerTimezone
        self.shouldUploadSelf = shouldUploadSelf
        self.shouldUploadPartner = shouldUploadPartner
        self.partnerShouldUpdateSelf = partnerShouldUpdateSelf
        self.partnerShouldUpdatePartner = partnerShouldUpdatePartner
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(withId: aDecoder.decodeObject(forKey: "id") as? String,
                  nickname: aDecoder.decodeObject(forKey: "nickname") as? String,
                  partnerNickname: aDecoder.decodeObject(forKey: "partnerNickname") as? String,
                  code: aDecoder.decodeObject(forKey: "code") as? String,
                  partnerCode: aDecoder.decodeObject(forKey: "partnerCode") as? String,
                  timezone: aDecoder.decodeObject(forKey: "timezone") as? String,
                  partnerTimezone: aDecoder.decodeObject(forKey: "partnerTimezone") as? String,
                  shouldUploadSelf: aDecoder.decodeObject(forKey: "shouldUploadSelf") as? Bool,
                  shouldUploadPartner: aDecoder.decodeObject(forKey: "shouldUploadPartner") as? Bool,
                  partnerShouldUpdateSelf: aDecoder.decodeObject(forKey: "partnerShouldUpdateSelf") as? Bool,
                  partnerShouldUpdatePartner: aDecoder.decodeObject(forKey: "partnerShouldUpdatePartner") as? Bool
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(partnerNickname, forKey: "partnerNickname")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(partnerCode, forKey: "partnerCode")
        aCoder.encode(timezone, forKey: "timezone")
        aCoder.encode(partnerTimezone, forKey: "partnerTimezone")
        aCoder.encode(shouldUploadSelf, forKey: "shouldUploadSelf")
        aCoder.encode(shouldUploadPartner, forKey: "shouldUploadPartner")
        aCoder.encode(partnerShouldUpdateSelf, forKey: "partnerShouldUpdateSelf")
        aCoder.encode(partnerShouldUpdatePartner, forKey: "partnerShouldUpdatePartner")
    }
}
