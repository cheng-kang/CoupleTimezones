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
        iconImage.tintColor = SLIDER_BG_DARK
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
