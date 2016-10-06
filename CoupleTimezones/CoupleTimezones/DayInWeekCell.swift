//
//  DayInWeekCell.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class DayInWeekCell: UITableViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var switchBtn: SwitchView!
    
    var switchOnCallback: ((_ isActive: Bool)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(withText text: String, isActive: Bool, switchOnCallback: ((_ isActive: Bool)->())?) {
        self.switchBtn.initSwitch(withIsActive: isActive)
        self.textLbl.text = text
        self.switchOnCallback = switchOnCallback
        
        self.switchBtn.toggleSwitchCallback = { isActive in
            self.switchOnCallback?(isActive)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
