//
//  TodayViewController.swift
//  RememberWidget1
//
//  Created by Ant on 21/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var table: UITableView!
    
    var isShowingSelf = false {
        didSet {
            if isShowingSelf != oldValue {
                self.table.reloadData()
                self.preferredContentSize = CGSize(width: 0, height: 110 + 25 + (isShowingSelf ? selfClocks.count : clocks.count ) * 34)
            }
        }
    }
    var clocks = [AlarmClock]()
    var selfClocks = [AlarmClock]()
    
    var tableSecCount = 3
    var contentHeight = 0
    
    var lastSelfDate = "" {
        didSet {
            if oldValue != lastSelfDate {
                updateWeather()
            }
        }
    }
    var lastPartnerDate = "" {
        didSet {
            if oldValue != lastPartnerDate {
                updateWeather()
            }
        }
    }
    var selfWeather: [String:String]? {
        didSet {
            if selfWeather != nil {
                table.reloadData()
            }
        }
    }
    var partnerWeather: [String:String]? {
        didSet {
            if partnerWeather != nil {
                table.reloadData()
            }
        }
    }
    
    // when weather data is null, set to true
    var isCityWrong = false {
        didSet {
            if isCityWrong == true {
                self.table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        updateDates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clocks.append(contentsOf: WidgetHelpers.shared.getPartnerNextClock())
        selfClocks.append(contentsOf: WidgetHelpers.shared.getSelfNextClock())
        
        contentHeight = 110 + 25 + (isShowingSelf ? selfClocks.count : clocks.count ) * 34
        updateDates()
        self.table.reloadData()
    }
    
    func updateDates() {
        lastSelfDate = Helpers.sharedInstance.getDatetimeText(fromDate: Date(), withFormat: "yyyy-MM-dd")
        lastPartnerDate = Helpers.sharedInstance.getDatetimeText(fromDate: WidgetHelpers.shared.getDateAtTimezone((WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone!)!), withFormat: "yyyy-MM-dd")
    }
    
    func updateWeather() {
        if let user = WidgetHelpers.shared.getCurrentUser() {
            if !WidgetHelpers.shared.isCitySet() {
                return
            }
            let partnerWeatherStr = (user.partnerCity ?? "") + "," + (user.partnerCountry ?? "")
            let selfWeatherStr = (user.city ?? "") + "," + (user.country ?? "")
            
            Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=\(selfWeatherStr)&appid=ae438196765929c4045ff867bb3e8fe0").responseJSON { response in
                self.selfWeather = nil
                self.selfWeather = [String:String]()
                
                if let data = response.result.value as? [String: Any] {
                    if let main = data["main"] as? [String: Any] {
                        let weather = (data["weather"] as! [Any])[0] as! [String: Any]
                        self.selfWeather!["temp"] = (main["temp"] as! Double).description
                        self.selfWeather!["high"] = (main["temp_max"] as! Double).description
                        self.selfWeather!["low"] = (main["temp_min"] as! Double).description
                        let icon = weather["icon"] as! String
                        let wId = weather["id"] as! Int
                        if wId > 950 {
                            self.selfWeather!["icon"] = "Additional"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 900 {
                            self.selfWeather!["icon"] = "Extreme"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 800 {
                            self.selfWeather!["icon"] = "Clouds"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId == 800 {
                            self.selfWeather!["icon"] = "Clear"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 700 {
                            self.selfWeather!["icon"] = "Atmosphere"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 600 {
                            self.selfWeather!["icon"] = "Snow"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 500 {
                            self.selfWeather!["icon"] = "Rain"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 300 {
                            self.selfWeather!["icon"] = "Drizzle"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 200 {
                            self.selfWeather!["icon"] = "Thunderstorm"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else {
                            self.selfWeather!["icon"] = "Atmosphered"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        }
                    } else {
                        self.isCityWrong = true
                    }
                } else {
                    self.isCityWrong = true
                }
            }
            
            Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=\(partnerWeatherStr)&appid=ae438196765929c4045ff867bb3e8fe0").responseJSON { response in
                self.partnerWeather = nil
                self.partnerWeather = [String:String]()
                
                if let data = response.result.value as? [String: Any] {
                    if let main = data["main"] as? [String: Any] {
                        let weather = (data["weather"] as! [Any])[0] as! [String: Any]
                        self.partnerWeather!["temp"] = (main["temp"] as! Double).description
                        self.partnerWeather!["high"] = (main["temp_max"] as! Double).description
                        self.partnerWeather!["low"] = (main["temp_min"] as! Double).description
                        let icon = weather["icon"] as! String
                        let wId = weather["id"] as! Int
                        if wId > 950 {
                            self.partnerWeather!["icon"] = "Additional"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 900 {
                            self.partnerWeather!["icon"] = "Extreme"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 800 {
                            self.partnerWeather!["icon"] = "Clouds"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId == 800 {
                            self.partnerWeather!["icon"] = "Clear"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 700 {
                            self.partnerWeather!["icon"] = "Atmosphere"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 600 {
                            self.partnerWeather!["icon"] = "Snow"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 500 {
                            self.partnerWeather!["icon"] = "Rain"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 300 {
                            self.partnerWeather!["icon"] = "Drizzle"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else if wId > 200 {
                            self.partnerWeather!["icon"] = "Thunderstorm"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        } else {
                            self.partnerWeather!["icon"] = "Atmosphered"+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
                        }
                    } else {
                        self.isCityWrong = true
                    }
                } else {
                    self.isCityWrong = true
                }
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize = CGSize(width: 0, height: contentHeight)
        }
    }
    
    
    
    
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSecCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isCityWrong || !WidgetHelpers.shared.isCitySet() {
                return 2
            }
            return 1
        } else if section == 1 {
            return isShowingSelf ? selfClocks.count : clocks.count
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sec = indexPath.section
        let row = indexPath.row
        if sec == 0 {
            if !WidgetHelpers.shared.isCitySet() && row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetAlertCell") as! WidgetAlertCell
                cell.msgLbl.text = NSLocalizedString("Click 'Show More' to set up for weather.", comment: "点击 展开，完成天气设置")
                return cell
            }
            if isCityWrong && row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetAlertCell") as! WidgetAlertCell
                cell.msgLbl.text = NSLocalizedString("Can't get weather for your cities, please check.", comment: "无法获取天气信息，请检查设置。")
                return cell
            }
            if WidgetHelpers.shared.isCitySet() && !isCityWrong && row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetDateAndWeatherCell") as! WidgetDateAndWeatherCell
                cell.configureCell(selfWeather: self.selfWeather, partnerWeather: self.partnerWeather) { flag in
                    self.isShowingSelf = flag
                }
                return cell
            }
            if (isCityWrong || !WidgetHelpers.shared.isCitySet()) && row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetDateAndWeatherCell") as! WidgetDateAndWeatherCell
                cell.configureCell(selfWeather: self.selfWeather, partnerWeather: self.partnerWeather) { flag in
                    self.isShowingSelf = flag
                }
                return cell
            }
        }
        if sec == 1 {
            let data = isShowingSelf ? selfClocks : clocks
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetAlarmClockCell") as! WidgetAlarmClockCell
            cell.configure(with: data[row])
            return cell
        }
        if sec == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetBtnsCell") as! WidgetBtnsCell
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sec = indexPath.section
        let row = indexPath.row
        if sec == 0 {
            if isCityWrong || !WidgetHelpers.shared.isCitySet(){
                if row == 0 {
                    return 20
                }
                return 90
            }
            return 110
        }
        if sec == 1 {
            return 34
        }
        if sec == 2 {
            return 25
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            self.extensionContext?.open(URL(string: "Remember://action=SetWidget")!, completionHandler: nil)
        }
    }
}
