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
    var currentUser: User?
    
    var tabledata = [AlarmClock]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentUser = UserService.shared.get()
        
        self.navLocLbl.text = TimeZone(identifier: UserService.shared.get()!.partnerTimeZone!)?.localizedName(for: .shortGeneric, locale: Locale.current)
        // start timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AlarmClockViewController.updateTimeLbl), userInfo: nil, repeats: true)
        timer!.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // deinit timer
        self.timer?.invalidate()
    }
    
    class func vc() -> AlarmClockViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AlarmClockViewController") as! AlarmClockViewController
        return vc
    }
    
    deinit {
    }
    
    func updateTimeLbl() {
        self.timerCount += 1
        
        let date = Helpers.sharedInstance.getDateAtTimezone(UserService.shared.get()!.partnerTimeZone!)
        
        self.navTimeLbl.text = (self.timerCount % 2 ) == 0 ? Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH:mm") : Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH mm")
        self.navPeriodLbl.text = Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "a")
    }
    
    func reloadData() {
        self.tabledata = AlarmClockService.shared.get()
        
        self.tableview.reloadData()
    }
    
    func deleteData(atIndex idx: Int) {
        // Pop out the item
        let item = self.tabledata.remove(at: idx)
        // Refresh table before deleting the record from database
        // So that it won't occur the case that
        // the cell to be deleted display on screen with no data
        self.tableview.reloadData()
        AlarmClockService.shared.delete(object: item)
    }

    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = NewAlarmClockViewController.vc {
            self.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnClick(_ sender: UIButton) {
        let settings = UserService.shared.get()!
        
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
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.timeZone!) ),
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.partnerTimeZone!)),
                ]) { results in
                    let user = UserService.shared.get()!
                    user.nickname = results[0] as! String
                    user.partnerNickname = results[1] as! String
                    user.code = results[2] as! String
                    user.partnerCode = results[3] as! String
                    user.timeZone = AVAILABLE_TIME_ZONE_LIST[(results[4] as! [Any])[0] as! Int]
                    user.partnerTimeZone = AVAILABLE_TIME_ZONE_LIST[(results[5] as! [Any])[0] as! Int]
                    
                    UserService.shared.save()
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
            
            cell.configureCell(with: tabledata[indexPath.row])
            
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
                let vc = NewAlarmClockViewController.vc(with: self.tabledata[indexPath.row], saveCallback: {
                    self.reloadData()
                })
                self.present(vc, animated: true, completion: nil)
            }
            edit.backgroundColor = SLIDER_BG_DARK
            
            let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "AlarmClock")) { (deleteAction, curIndexPath) in
                
                self.deleteData(atIndex: indexPath.row)
            }
            delete.backgroundColor = SLIDER_BLOCK
            
            return [delete, edit]
        } else {
            return []
        }
    }
}
