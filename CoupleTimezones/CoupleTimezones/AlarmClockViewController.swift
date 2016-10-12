//
//  AlarmClockViewController
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class AlarmClockViewController: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var navTimeLbl: UILabel!
    @IBOutlet weak var navLocLbl: UILabel!
    @IBOutlet weak var navPeriodLbl: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    var tabledata = [AlarmClockModel]()
    var selfAlarmCount: Int = 0
    
    var timer: Timer?
    var timerCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.reloadData()
        
        // init tableview
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
        
        // add notification reciever
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.reloadData), name: NSNotification.Name(rawValue: "AlarmClockDataSynchronized"), object: nil)
        
        
        UserData.sharedInstance.syncDataWithServer { (isSuccess) in
            if isSuccess {
                 self.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navLocLbl.text = TimeZone(identifier: UserData.sharedInstance.getUserSettings().partnerTimezone!)?.localizedName(for: .shortGeneric, locale: Locale.current)
        // start timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AlarmClockViewController.updateTimeLbl), userInfo: nil, repeats: true)
        timer!.fire()
    }
    
    func updateTimeLbl() {
        self.timerCount += 1
        
        let settings = UserData.sharedInstance.getUserSettings()
        
        let date = Helpers.sharedInstance.getDateAtTimezone(settings.partnerTimezone!)
        
        self.navTimeLbl.text = (self.timerCount % 2 ) == 0 ? Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH:mm") : Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH mm")
        self.navPeriodLbl.text = Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "a")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // deinit timer
        self.timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func vc() -> AlarmClockViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AlarmClockViewController") as! AlarmClockViewController
        return vc
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AlarmClockDataSynchronized"), object: nil)
    }
    
    // reload data from user defaults
    func reloadData() {
        let (allData, selfAlarmCount) = UserData.sharedInstance.getAlarmClockAll()
        self.tabledata = allData
        self.selfAlarmCount = selfAlarmCount
        
        self.tableview.reloadData()
    }
    
    // save data to user defaults
    func saveData(atIndex idx: Int) {
        let isSelf = self.tabledata.count <= self.selfAlarmCount
        let relIndex = isSelf ? idx : idx - self.selfAlarmCount
        UserData.sharedInstance.updateAlarmClock(ofSelf: isSelf, atIndex: relIndex, withElement: self.tabledata[idx], callback: { isSuccess in
            if isSuccess {
                self.reloadData()
            }
        })
    }

    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = NewAlarmClockViewController.vc {
            self.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnClick(_ sender: UIButton) {
        let settings = UserData.sharedInstance.getUserSettings()
        
        SlidingFormPageConfig.sharedInstance.customFontName = "FZYanSongS-R-GB"
        
        let vc = SlidingFormViewController.vc(
            withStoryboardName: "Main",
            bundle: nil,
            identifier: "SlidingFormViewController",
            andFormTitle: NSLocalizedString("Settings",comment: "SlidingForm"),
            pages: [
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your nickname.", comment: "SlidingForm"), defaultValue: settings.nickname, errorMsg: "长度至少一位"),
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your partner's nickname.", comment: "SlidingForm"), defaultValue: settings.partnerNickname, errorMsg: "长度至少一位"),
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter a special code to identify yourself.\nFormat:\n4 or more characters, consisting only letters and numbers.\nUsage: When the two codes (your code and your partner's code) match with another pair of codes set by another user, your accounts are matched. Matched users will share their alarm clocks.", comment: "SlidingForm"), defaultValue: settings.code, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成"),
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please ask your partner for his/her Code.", comment: "SlidingForm"), defaultValue: settings.partnerCode, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成"),
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.timezone!) ),
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.partnerTimezone!)),
                ]) { results in
                    settings.nickname = results[0] as! String
                    settings.partnerNickname = results[1] as! String
                    settings.code = results[2] as! String
                    settings.partnerCode = results[3] as! String
                    settings.timezone = AVAILABLE_TIME_ZONE_LIST[(results[4] as! [Any])[0] as! Int]
                    settings.partnerTimezone = AVAILABLE_TIME_ZONE_LIST[(results[5] as! [Any])[0] as! Int]
                    
                    UserData.sharedInstance.updateUserSettings(withUserSettings: settings)
        }
        self.present(vc, animated: true, completion: nil)
    }

}

extension AlarmClockViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count == 0 ? 1 : tabledata.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabledata.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmClockCell") as! AlarmClockCell
            
            cell.configureCell(withAlarmClockData: tabledata[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoContentCell") as! NoContentCell
            cell.configureCell(withText: NSLocalizedString("No Alarm Clock", comment: "AlarmClock"))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if tabledata.count > 0 {
            let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "AlarmClock")) { (editAction, curIndexPath) in
                let vc = NewAlarmClockViewController.vc(withElement: self.tabledata[indexPath.row], index: indexPath.row, saveCallback: {
                    self.reloadData()
                })
                self.present(vc, animated: true, completion: nil)
            }
            edit.backgroundColor = SLIDER_BG_DARK
            
            let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "AlarmClock")) { (deleteAction, curIndexPath) in
                self.tabledata.remove(at: curIndexPath.row)
                
                self.saveData(atIndex: indexPath.row)
            }
            delete.backgroundColor = SLIDER_BLOCK
            
            return [delete, edit]
        } else {
            return []
        }
    }
}
