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
        self.switchBtn.initSwitch(isActive, animated: true)
        self.textLbl.text = text
        self.textLbl.textColor = Theme.shared.repeat_cell_text
        self.switchOnCallback = switchOnCallback
        
        self.switchBtn.toggleSwitchCallback = { isActive in
            self.switchOnCallback?(isActive)
        }
    }
}
