//
//  AttentionCell.swift
//  CoupleTimezones
//
//  Created by Ant on 15/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class AttentionCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImage.image = UIImage(named: "Attention")!.withRenderingMode(.alwaysTemplate)
        iconImage.tintColor = Theme.shared.banner_btn
        
        self.msgLbl.textColor = Theme.shared.alarm_cell_text_active
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
