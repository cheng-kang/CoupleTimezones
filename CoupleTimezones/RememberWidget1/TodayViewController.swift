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
    
    var selfNext: AlarmClock?
    var partnerNext: AlarmClock?
    
    var tableCellCount = 2
    var contentHeight = 110 + 30
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()

//        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        updateDates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selfNext = WidgetHelpers.shared.getSelfNextClock()
        partnerNext = WidgetHelpers.shared.getPartnerNextClock()
        
        // DateAndWeather cell & Settings cell
        if selfNext != nil {
            contentHeight += 90
            tableCellCount += 1
        }
        if partnerNext != nil {
            contentHeight += 90
            tableCellCount += 1
        }
        if selfNext == nil && partnerNext == nil {
            contentHeight += 90
            tableCellCount += 1
        }
        updateDates()
        self.table.reloadData()
    }
    
    func updateDates() {
        lastSelfDate = Helpers.sharedInstance.getDatetimeText(fromDate: Date(), withFormat: "yyyy-MM-dd")
        lastPartnerDate = Helpers.sharedInstance.getDatetimeText(fromDate: WidgetHelpers.shared.getDateAtTimezone((WidgetHelpers.shared.getCurrentUser()?.partnerTimeZone!)!), withFormat: "yyyy-MM-dd")
    }
    
    func updateWeather() {
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=southampton,uk&appid=ae438196765929c4045ff867bb3e8fe0").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            self.selfWeather = nil
            self.selfWeather = [String:String]()
            
            if let data = response.result.value as? [String: Any] {
                let main = data["main"] as! [String: Any]
                let weather = (data["weather"] as! [Any])[0] as! [String: Any]
                self.selfWeather!["temp"] = (main["temp"] as! Double).description
                self.selfWeather!["high"] = (main["temp_max"] as! Double).description
                self.selfWeather!["low"] = (main["temp_min"] as! Double).description
                let icon = weather["icon"] as! String
                self.selfWeather!["icon"] = (weather["main"] as! String)+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
            }
        }
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?q=irvine,us&appid=ae438196765929c4045ff867bb3e8fe0").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            self.partnerWeather = nil
            self.partnerWeather = [String:String]()
            
            if let data = response.result.value as? [String: Any] {
                let main = data["main"] as! [String: Any]
                let weather = (data["weather"] as! [Any])[0] as! [String: Any]
                self.partnerWeather!["temp"] = (main["temp"] as! Double).description
                self.partnerWeather!["high"] = (main["temp_max"] as! Double).description
                self.partnerWeather!["low"] = (main["temp_min"] as! Double).description
                let icon = weather["icon"] as! String
                self.partnerWeather!["icon"] = (weather["main"] as! String)+icon.substring(from: icon.index(icon.endIndex, offsetBy: -1))
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetDateAndWeatherCell") as! WidgetDateAndWeatherCell
            cell.configureCell(selfWeather: self.selfWeather, partnerWeather: self.partnerWeather)
            return cell
        }
        if partnerNext != nil && row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetAlarmClockCell") as! WidgetAlarmClockCell
            cell.configureCell(with: partnerNext!)
            return cell
        }
        if selfNext != nil && ((partnerNext == nil && row == 1) || (partnerNext != nil && row == 2)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetAlarmClockCell") as! WidgetAlarmClockCell
            cell.configureCell(with: selfNext!)
            return cell
        }
        if partnerNext == nil && selfNext == nil && row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetMsgCell") as! WidgetMsgCell
            
            return cell
        }
        if row == tableCellCount-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetBtnsCell") as! WidgetBtnsCell
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == 0 {
            return 110
        }
        if row == tableCellCount-1 {
            return 40
        }
        return 90
    }
}
