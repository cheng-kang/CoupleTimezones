//
//  AlarmClockHelperModel.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/12.
//  Copyright © 2016年 Ant. All rights reserved.
//

import Foundation

class AlarmClockHelperModel: NSObject {
    private var _isSetBySelf: Bool!
    
    private var _time: String!
    private var _period: String!
    private var _partnerTime: String!
    private var _partnerPeriod: String
    private var _partnerNickname: String!
    
    var _isShowingSelf: Bool!
    
    var labelTexts: (String, String, String) {
        self._isShowingSelf = !self._isShowingSelf
        
        let time: String = _isShowingSelf == true ? _partnerTime : _time
        let period: String = _isShowingSelf == true ? _partnerPeriod : _period
        
        var partnerCalendar = Calendar.current
        partnerCalendar.timeZone = TimeZone(identifier: UserData.sharedInstance.getUserSettings().partnerTimezone!)!
        let isYesterday = partnerCalendar.isDateInYesterday(Helpers.sharedInstance.getDateTodayAtTime(_time, inFormat: "HH:mm"))
        let isTommorrow = partnerCalendar.isDateInTomorrow(Helpers.sharedInstance.getDateTodayAtTime(_time, inFormat: "HH:mm"))
        let dayDiffString = isYesterday ? "-1 " : isTommorrow ? "+1 " : ""
        
        let desc: String = _isShowingSelf == true ? dayDiffString + _partnerNickname + NSLocalizedString("'s Time", comment: "的时间") : NSLocalizedString("My Time", comment: "我的时间")
        
        return (time, period, desc)
    }
    
    init(isSetBySelf: Bool, time: String, period: String) {
        self._isSetBySelf = isSetBySelf
        self._isShowingSelf = !_isSetBySelf
        
        let settings = UserData.sharedInstance.getUserSettings()
        
        if isSetBySelf {
            let dateAtTimeInPartnerTimeZone = Helpers.sharedInstance.getDateTodayAtTime(time, inFormat: "HH:mm")
            
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(settings.partnerTimezone!)
            
            let dateAtTimeInLocalTimeZone = dateAtTimeInPartnerTimeZone.addingTimeInterval(timeInterval)
            
            self._time = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "HH:mm")
            self._period = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "a")
            
            self._partnerTime = time
            self._partnerPeriod = period
            self._partnerNickname = settings.partnerNickname!
        } else {
            let dateAtTimeInLocalTimeZone = Helpers.sharedInstance.getDateTodayAtTime(time, inFormat: "HH:mm")
            
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(settings.partnerTimezone!)
            
            let dateAtTimeInPartnerTimeZone = dateAtTimeInLocalTimeZone.addingTimeInterval(-timeInterval)
            
            
            self._time = time
            self._period = period
            
            self._partnerTime = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInPartnerTimeZone, withFormat: "HH:mm")
            self._partnerPeriod = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInPartnerTimeZone, withFormat: "HH:mm")
            self._partnerNickname = settings.partnerNickname!
        }
    }
}
