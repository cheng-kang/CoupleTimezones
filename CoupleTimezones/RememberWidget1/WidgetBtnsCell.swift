//
//  WidgetBtnsCell.swift
//  CoupleTimezones
//
//  Created by Ant on 21/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class WidgetBtnsCell: UITableViewCell {

    @IBOutlet weak var settingBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        settingBtn.setImage(UIImage(named: "Setting")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingBtn.tintColor = UIColor.lightText
    }

    @IBAction func settingBtnOnPress(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
