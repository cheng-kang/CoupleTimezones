//
//  AlarmClockCell.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class AlarmClockCell: UITableViewCell {
    
    @IBOutlet var daysSquareViews: [UIView]!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var isActiveSwitch: SwitchView!
    
    var alarmClock: AlarmClock!
    
    var myLabelTexts: (time: String, period: String, desc: String)!
    var partnerLabelTexts: (time: String, period: String, desc: String)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AlarmClockCell.toggleLblText))
        self.addGestureRecognizer(tap)
        
        // Handle switch event
        self.isActiveSwitch.toggleSwitchCallback = { isActive in
            // Save the change once toggled
            self.alarmClock.isActive = isActive
            AlarmClockService.shared.saveAndUploadSingle(self.alarmClock)
            // Reschedule local notification
            
            if isActive {
                for i in 0..<self.alarmClock.days.count {
                    self.daysSquareViews[i].backgroundColor = self.alarmClock.days[i] ? Theme.shared.alarm_cell_day_active : Theme.shared.alarm_cell_day_inactive
                }
                self.isActiveSwitch.backgroundColor = Theme.shared.switch_bg_inactive
                self.isActiveSwitch.layer.borderColor = Theme.shared.switch_border.cgColor
                self.isActiveSwitch.bgLeftActiveView.backgroundColor = Theme.shared.switch_bg_active
                self.isActiveSwitch.switchButtonView.backgroundColor = Theme.shared.switch_block
                
                self.periodLbl.textColor = Theme.shared.alarm_cell_text_active
                self.timeLbl.textColor = Theme.shared.alarm_cell_text_active
                self.locationLbl.textColor = Theme.shared.alarm_cell_text_active
                self.contentLbl.textColor = Theme.shared.alarm_cell_text_active
            } else {
                for i in 0..<self.alarmClock.days.count {
                    self.daysSquareViews[i].backgroundColor = Theme.shared.alarm_cell_day_inactive
                }
                self.isActiveSwitch.backgroundColor = Theme.shared.switch_bg_inactive
                self.isActiveSwitch.layer.borderColor = Theme.shared.switch_bg_active.cgColor
                self.isActiveSwitch.bgLeftActiveView.backgroundColor = Theme.shared.switch_bg_active
                self.isActiveSwitch.switchButtonView.backgroundColor = Theme.shared.switch_bg_active
                
                self.periodLbl.textColor = Theme.shared.alarm_cell_text_inactive
                self.timeLbl.textColor = Theme.shared.alarm_cell_text_inactive
                self.locationLbl.textColor = Theme.shared.alarm_cell_text_inactive
                self.contentLbl.textColor = Theme.shared.alarm_cell_text_inactive
            }
            
        }
    }
    
    // Toggle between lbls of
    // user's time/timezone/location 
    // and partner's time/timezone/location
    var isShowingPartnerText = false
    func toggleLblText() {
        alarmClock.isShowingPartnerText = !alarmClock.isShowingPartnerText
        AlarmClockService.shared.save()
        
        if alarmClock.isShowingPartnerText {
            showPartnerText()
        } else {
            showMyText()
        }
    }
    func showMyText() {
        let (timeText, periodText, descText) = myLabelTexts
        self.locationLbl.text = descText
        self.timeLbl.text = timeText
        self.periodLbl.text = periodText
    }
    func showPartnerText() {
        let (timeText, periodText, descText) = partnerLabelTexts
        self.locationLbl.text = descText
        self.timeLbl.text = timeText
        self.periodLbl.text = periodText
    }
    
    func configureCell(with data: AlarmClock) {
        self.alarmClock = data
        
        self.periodLbl.text = data.period
        self.timeLbl.text = data.time
        self.contentLbl.text = data.tag
        
        let currentUser = UserService.shared.get()!
        // Init lbls
        if data.timeZone == UserService.shared.get()?.timeZone {
            myLabelTexts = (data.time!, data.period!, NSLocalizedString("My Time", comment: "我的时间"))
            
            let date = Helpers.sharedInstance.getDateTodayAtTime(data.time!, inFormat: "HH:mm")
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(currentUser.partnerTimeZone!)
            let dateInPartnerTimeZone = date.addingTimeInterval(-timeInterval)
            let partnerTime = Helpers.sharedInstance.getDatetimeText(fromDate: dateInPartnerTimeZone, withFormat: "HH:mm")
            let partnerPeriod = Helpers.sharedInstance.getDatetimeText(fromDate: dateInPartnerTimeZone, withFormat: "a")
            
            let partnerDesc: String = currentUser.partnerNickname! + NSLocalizedString("'s Time", comment: "的时间")
            partnerLabelTexts = (partnerTime, partnerPeriod, partnerDesc)
        } else {
            
            let dateAtTimeInPartnerTimeZone = Helpers.sharedInstance.getDateTodayAtTime(data.time!, inFormat: "HH:mm")
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(currentUser.partnerTimeZone!)
            let dateAtTimeInLocalTimeZone = dateAtTimeInPartnerTimeZone.addingTimeInterval(timeInterval)
            
            let time = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "HH:mm")
            let period = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "a")
            
            myLabelTexts = (time, period, NSLocalizedString("My Time", comment: "我的时间"))
            
            let partnerDesc: String = currentUser.partnerNickname! + NSLocalizedString("'s Time", comment: "的时间")
            
            partnerLabelTexts = (data.time!, data.period!, partnerDesc)
        }
        
        if data.isShowingPartnerText {
            self.showPartnerText()
        } else {
            self.showMyText()
        }
        
        
        if data.isActive {
            for i in 0..<data.days.count {
                daysSquareViews[i].backgroundColor = data.days[i] ? Theme.shared.alarm_cell_day_active : Theme.shared.alarm_cell_day_inactive
            }
            isActiveSwitch.backgroundColor = Theme.shared.switch_bg_inactive
            isActiveSwitch.layer.borderColor = Theme.shared.switch_border.cgColor
            isActiveSwitch.bgLeftActiveView.backgroundColor = Theme.shared.switch_bg_active
            isActiveSwitch.switchButtonView.backgroundColor = Theme.shared.switch_block
            
            self.periodLbl.textColor = Theme.shared.alarm_cell_text_active
            self.timeLbl.textColor = Theme.shared.alarm_cell_text_active
            self.locationLbl.textColor = Theme.shared.alarm_cell_text_active
            self.contentLbl.textColor = Theme.shared.alarm_cell_text_active
        } else {
            for i in 0..<data.days.count {
                daysSquareViews[i].backgroundColor = Theme.shared.alarm_cell_day_inactive
            }
            isActiveSwitch.backgroundColor = Theme.shared.switch_bg_inactive
            isActiveSwitch.layer.borderColor = Theme.shared.switch_bg_active.cgColor
            isActiveSwitch.bgLeftActiveView.backgroundColor = Theme.shared.switch_bg_active
            isActiveSwitch.switchButtonView.backgroundColor = Theme.shared.switch_bg_active
            
            self.periodLbl.textColor = Theme.shared.alarm_cell_text_inactive
            self.timeLbl.textColor = Theme.shared.alarm_cell_text_inactive
            self.locationLbl.textColor = Theme.shared.alarm_cell_text_inactive
            self.contentLbl.textColor = Theme.shared.alarm_cell_text_inactive
        }
        
        
        isActiveSwitch.initSwitch(data.isActive)
    }
    
    deinit {
        // Remove all gesture recognizers
        self.gestureRecognizers?.forEach({ (gr) in
            self.removeGestureRecognizer(gr)
        })
    }
}
