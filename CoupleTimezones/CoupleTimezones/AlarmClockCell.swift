//
//  AlarmClockCell.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class AlarmClockCellHelperModel: NSObject {
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
        let isYesterday = partnerCalendar.isDateInYesterday(Helpers.sharedInstance.getDateOfTodayAtTime(_time, inFormat: "HH:mm"))
        let isTommorrow = partnerCalendar.isDateInTomorrow(Helpers.sharedInstance.getDateOfTodayAtTime(_time, inFormat: "HH:mm"))
        let dayDiffString = isYesterday ? "-1 " : isTommorrow ? "+1 " : ""
        
        let desc: String = _isShowingSelf == true ? dayDiffString + _partnerNickname + NSLocalizedString("'s Time", comment: "的时间") : NSLocalizedString("My Time", comment: "我的时间")
        
        return (time, period, desc)
    }
    
    init(isSetBySelf: Bool, time: String, period: String) {
        self._isSetBySelf = isSetBySelf
        self._isShowingSelf = !_isSetBySelf
        
        let settings = UserData.sharedInstance.getUserSettings()
        
        if isSetBySelf {
            let dateAtTimeInPartnerTimeZone = Helpers.sharedInstance.getDateOfTodayAtTime("06:00", inFormat: "HH:mm")
            
            let timeInterval = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(settings.partnerTimezone!)
            
            let dateAtTimeInLocalTimeZone = dateAtTimeInPartnerTimeZone.addingTimeInterval(timeInterval)
            
            self._time = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "HH:mm")
            self._period = Helpers.sharedInstance.getDatetimeText(fromDate: dateAtTimeInLocalTimeZone, withFormat: "a")
            
            self._partnerTime = time
            self._partnerPeriod = period
            self._partnerNickname = settings.partnerNickname!
        } else {
            let dateAtTimeInLocalTimeZone = Helpers.sharedInstance.getDateOfTodayAtTime(time, inFormat: "HH:mm")
            
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

class AlarmClockCell: UITableViewCell {
    
    @IBOutlet var daysSquareViews: [UIView]!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var sliderBlockView: UIView!
    @IBOutlet weak var toggleSliderBtn: UIButton!
    
    @IBOutlet weak var sliderBlockTrailToRightConstraint: NSLayoutConstraint!
    
    var alarmClock: AlarmClockModel!
    var cellHelper: AlarmClockCellHelperModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AlarmClockCell.toggleTimezone))
        self.addGestureRecognizer(tap)
    }
    
    func toggleTimezone() {
        let (timeText, periodText, descText) = cellHelper.labelTexts
        self.locationLbl.text = descText
        self.timeLbl.text = timeText
        self.periodLbl.text = periodText
    }
    
    deinit {
        self.gestureRecognizers?.forEach({ (gr) in
            self.removeGestureRecognizer(gr)
        })
    }
    
    @IBAction func toggleSliderBtnClick(_ sender: UIButton) {
        self.toggleSlider()
    }
    
    func toggleSlider(animated: Bool = true) {
        let distantToMove: CGFloat = (self.frame.width - self.sliderBlockView.frame.origin.x - self.sliderBlockView.frame.width) == 35 ? 26 : -26
        let newCenter = CGPoint(x: self.sliderBlockView.center.x + distantToMove, y: self.sliderBlockView.center.y)
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.sliderBlockView.center = newCenter
            }
        } else {
            self.sliderBlockView.center = newCenter
        }
    }
    
    func configureCell(withAlarmClockData data: AlarmClockModel) {
        self.alarmClock = data
        
        self.periodLbl.text = data.period
        self.timeLbl.text = data.time
        self.contentLbl.text = data.tag
    
        self.cellHelper = AlarmClockCellHelperModel(isSetBySelf: data.isSetBySelf!, time: data.time!, period: data.period!)
        
        self.toggleTimezone()
        
        for i in 0..<data.days!.count {
            daysSquareViews[i].backgroundColor = data.days![i] ? DAY_SQUARE_DARK : DAY_SQUARE_LIGHT
        }
        
        if data.isActive == true {
            self.sliderBlockTrailToRightConstraint.constant = 9
        } else {
            self.sliderBlockTrailToRightConstraint.constant = 35
        }
    }

}
