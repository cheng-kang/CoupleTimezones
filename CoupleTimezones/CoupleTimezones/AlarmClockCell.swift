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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
        self.locationLbl.text = data.location
        self.contentLbl.text = data.content
        
        for i in 0..<data.days.count {
            daysSquareViews[i].backgroundColor = data.days[i] ? DAY_SQUARE_DARK : DAY_SQUARE_LIGHT
        }
        
        if data.isActive == true {
            self.sliderBlockTrailToRightConstraint.constant = 9
        } else {
            self.sliderBlockTrailToRightConstraint.constant = 35
        }
    }

}
