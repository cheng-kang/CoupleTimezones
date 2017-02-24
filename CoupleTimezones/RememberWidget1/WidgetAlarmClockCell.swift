//
//  WidetAlarmClockCell.swift
//  CoupleTimezones
//
//  Created by Ant on 22/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class WidgetAlarmClockCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isUserInteractionEnabled = true
        
        icon.image = UIImage(named: "Alarm")
//            .withRenderingMode(.alwaysTemplate)
//        icon.tintColor = UIColor.darkText
    }
    
    func configure(with data: AlarmClock) {
        self.timeLbl.text = WidgetHelpers.shared.getDatetimeText(fromDate: Helpers.sharedInstance.getDateTodayAtTime(data.time!), withFormat: "a") + " " + data.time!
        self.tagLbl.text = data.tag
    }
}
