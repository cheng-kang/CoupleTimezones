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
    @IBOutlet weak var selfTimeLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var periodLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var scaleLbl: UILabel!
    @IBOutlet weak var aveTempLbl: UILabel!
    @IBOutlet weak var highTempLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    
    // for partner
    var timer: Timer?
    var timerCount = 0
    
    // for self
    var selfTimer: Timer?
    var selfTimerCount = 0
    
    var selfWeather: [String:String]?
    var partnerWeather: [String:String]?
    
    var isShowingTemp = false
    var isShowingSelf = false
    var isShowingFScale = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dateLbl.text = Helpers.sharedInstance.getDatetimeText(fromDate: WidgetHelpers.shared.getDateAtTimezone((WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone!)!),
                                                                   withFormat: "EEEE, MMM d, yyyy")
        self.locLbl.text = TimeZone(identifier: (WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone)!)?.localizedName(for: .shortGeneric, locale: Locale.current)
        // start timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(WidgetDateAndWeatherCell.updateTimeLbl), userInfo: nil, repeats: true)
        timer!.fire()
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.toggleTexts))
        self.addGestureRecognizer(tap1)
    }
    
    func updateTimeLbl() {
        self.timerCount += 1
        
        let date = WidgetHelpers.shared.getDateAtTimezone((WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone!)!)
        
        self.timeLbl.text = (self.timerCount % 2 ) == 0 ? WidgetHelpers.shared.getDatetimeText(fromDate: date, withFormat: "HH:mm") : WidgetHelpers.shared.getDatetimeText(fromDate: date, withFormat: "HH mm")
        
        self.selfTimerCount += 1
        
        self.selfTimeLbl.text = (self.selfTimerCount % 2 ) == 0 ? WidgetHelpers.shared.getDatetimeText(fromDate: Date(), withFormat: "HH:mm") : WidgetHelpers.shared.getDatetimeText(fromDate: Date(), withFormat: "HH mm")
        
        if isShowingSelf {
            self.periodLbl.text = WidgetHelpers.shared.getDatetimeText(fromDate: Date(), withFormat: "a")
        } else {
            self.periodLbl.text = WidgetHelpers.shared.getDatetimeText(fromDate: date, withFormat: "a")
        }
    }
    
    func configureCell(selfWeather: [String:String]?, partnerWeather: [String:String]?) {
        self.selfWeather = selfWeather
        self.partnerWeather = partnerWeather
        
        self.isShowingTemp = self.selfWeather != nil || self.partnerWeather != nil
        if self.isShowingTemp {
            showCScale()
        } else {
            clearTempText()
        }
    }
    
    func toggleTexts() {
        isShowingSelf = !isShowingSelf
        if isShowingSelf {
            self.timeLbl.isHidden = true
            self.selfTimeLbl.isHidden = false
            
            self.dateLbl.text = Helpers.sharedInstance.getDatetimeText(fromDate: Date(),
                                                                       withFormat: "EEEE, MMM d, yyyy")
            self.locLbl.text = TimeZone(identifier: (WidgetHelpers.shared.getCurrentUser()?.timeZone)!)?.localizedName(for: .shortGeneric, locale: Locale.current)
        } else {
            self.timeLbl.isHidden = false
            self.selfTimeLbl.isHidden = true
            
            self.dateLbl.text = Helpers.sharedInstance.getDatetimeText(fromDate: WidgetHelpers.shared.getDateAtTimezone((WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone!)!),
                                                                       withFormat: "EEEE, MMM d, yyyy")
            self.locLbl.text = TimeZone(identifier: (WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone)!)?.localizedName(for: .shortGeneric, locale: Locale.current)
        }
        showCScale()
    }
    @IBAction func toggleTemp(_ sender: UIButton) {
        isShowingFScale = !isShowingFScale
        if isShowingFScale {
            showFScale()
        } else {
            showCScale()
        }
    }
    
    func showFScale() {
        if let weather = isShowingSelf ? selfWeather : partnerWeather {
            self.weatherImage.image = UIImage(named: weather["icon"]!)!
            self.scaleLbl.text = "°F"
            self.aveTempLbl.text = String(format: "%.1f", (Double(weather["temp"]!)! * 9.0 / 5.0 - 459.67))
            self.highTempLbl.text = String(format: "%.1f", (Double(weather["high"]!)! * 9.0 / 5.0 - 459.67))
            self.lowTempLbl.text =  String(format: "%.1f", (Double(weather["low"]!)! * 9.0 / 5.0 - 459.67))
        } else {
            clearTempText()
        }
    }
    func showCScale() {
        if let weather = isShowingSelf ? selfWeather : partnerWeather {
            self.weatherImage.image = UIImage(named: weather["icon"]!)!
            self.scaleLbl.text = "°C"
            self.aveTempLbl.text = String(format: "%.1f", (Double(weather["temp"]!)! - 273.15))
            self.highTempLbl.text = String(format: "%.1f", Double(weather["high"]!)! - 273.15)
            self.lowTempLbl.text = String(format: "%.1f", Double(weather["low"]!)! - 273.15)
        } else {
            clearTempText()
        }
    }
    func clearTempText() {
        self.weatherImage.image = nil
        self.scaleLbl.text = ""
        self.aveTempLbl.text = ""
        self.highTempLbl.text = ""
        self.lowTempLbl.text = ""
    }
    
    deinit {
        self.timer?.invalidate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
