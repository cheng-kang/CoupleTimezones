//
//  WidgetDateAndWeatherCell.swift
//  CoupleTimezones
//
//  Created by Ant on 21/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class WidgetDateAndWeatherCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var scaleLbl: UILabel!
    @IBOutlet weak var aveTempLbl: UILabel!
    @IBOutlet weak var highTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
