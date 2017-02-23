//
//  WidgetNoContentCell.swift
//  CoupleTimezones
//
//  Created by Ant on 22/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class WidgetAlertCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        icon.image = UIImage(named: "Attention")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor.darkText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
