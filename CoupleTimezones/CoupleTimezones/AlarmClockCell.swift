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
    @IBOutlet weak var sliderBlockView: UIView!
    @IBOutlet weak var toggleSliderBtn: UIButton!
    
    @IBOutlet weak var sliderBlockTrailToRightConstraint: NSLayoutConstraint!
    
    var alarmClock: AlarmClockModel!
    var cellHelper: AlarmClockHelperModel!
    
    var toggleSliderCallback: ((_ isActive: Bool)->())?
    
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
    
    @IBAction func toggleSliderBtnClick(sender: UIButton) {
        self.toggleSlider()
    }
    
    func toggleSlider(animated: Bool = true) {
        let isActive = (self.frame.width - self.sliderBlockView.frame.origin.x - self.sliderBlockView.frame.width) == 35
        let distantToMove: CGFloat = isActive ? 26 : -26
        let newCenter = CGPoint(x: self.sliderBlockView.center.x + distantToMove, y: self.sliderBlockView.center.y)
        
//        if animated {
//            UIView.animate(withDuration: 0.3) {
//                self.sliderBlockView.center = newCenter
//            }
//        } else {
//            self.sliderBlockView.center = newCenter
//        }
        
        UIView.animate(withDuration: 0.3) {
            self.sliderBlockView.center = newCenter
        }
        
        if isActive {
            // 此处需要更新 alarmClock 数据
            
            Helpers.sharedInstance.scheduleLocalNotification(self.alarmClock)
        } else {
            Helpers.sharedInstance.cancelLocalNotification(self.alarmClock._id!)
        }
        
        toggleSliderCallback?(isActive)
    }
    
    func configureCell(withAlarmClockData data: AlarmClockModel, toggleSliderCallback: ((_ isActive: Bool)->())?) {
        self.alarmClock = data
        self.toggleSliderCallback = toggleSliderCallback
        
        self.periodLbl.text = data.period
        self.timeLbl.text = data.time
        self.contentLbl.text = data.tag
    
        self.cellHelper = AlarmClockHelperModel(isSetBySelf: data.isSetBySelf!, time: data.time!, period: data.period!)
        
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
