//
//  NoContentCell.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class NoContentCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLbl.alpha = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(withText text: String) {
        self.textLbl.text = text
        self.textLbl.textColor = Theme.shared.alarm_cell_text_inactive
    }
}
