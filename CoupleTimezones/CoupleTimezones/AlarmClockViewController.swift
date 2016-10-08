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
    
    var tabledata = [AlarmClockModel]() {
        didSet {
            tableview.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserDefaults.standard.removeObject(forKey: "AlarmClock")
        UserDefaults.standard.synchronize()
        
        print(UserDefaults.standard.object(forKey: "AlarmClock"))
        self.reloadData()
        
        // init tableview
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
        
        // add notification reciever
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.reloadData), name: NSNotification.Name(rawValue: "AlarmClockDataSynchronized"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AlarmClockDataSynchronized"), object: nil)
    }
    
    // reload data from user defaults
    func reloadData() {
        self.tabledata = UserData.sharedInstance.getAlarmClock()
    }
    
    // save data to user defaults
    func saveData() {
        if UserData.sharedInstance.updateAlarmClock(withList: self.tabledata) {
            Helpers.sharedInstance.toast(withString: "Success")
        } else {
            Helpers.sharedInstance.toast(withString: "Fail")
        }
    }

    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = NewAlarmClockViewController.vc {
            // some callback thing
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnClick(_ sender: UIButton) {
        let settings = UserData.sharedInstance.getUserSettings()
        
        SlidingFormPageConfig.sharedInstance.customFontName = "FZYanSongS-R-GB"
        
        let vc = SlidingFormViewController.vc(withStoryboardName: "Main", bundle: nil, identifier: "SlidingFormViewController", andFormTitle: "自定义设置", pages: [
                SlidingFormPage.getInput(withTitle: "你的昵称", isRequired: true, desc: "请在此输入一个你喜欢的昵称。", defaultValue: settings.nickname),
                SlidingFormPage.getInput(withTitle: "对方的昵称", isRequired: true, desc: "请在此输入一个对方的昵称。", defaultValue: settings.partnerNickname),
                SlidingFormPage.getInput(withTitle: "你的神秘代码", isRequired: true, desc: "请输入一个用于标识你的身份的神秘代码。/n格式：/n四位以上，由数字和字母组成。/n用途：/n当你输入的 神秘代码 和 对方的神秘代码 与另一位用户的两个神秘代码吻合时，你们就配对成功了。配对成功后，你们的闹钟数据会自动同步。", defaultValue: settings.code),
                SlidingFormPage.getInput(withTitle: "对方的神秘代码", isRequired: true, desc: "请询问对方的神秘代码，并输入。/n格式：/n四位以上，由数字和字母组成。/n用途：/n当你输入的 神秘代码 和 对方的神秘代码 与另一位用户的两个神秘代码吻合时，你们就配对成功了。配对成功后，你们的闹钟数据会自动同步。", defaultValue: settings.partnerCode),
                SlidingFormPage.getSelect(withTitle: "你的时区", desc: nil, selectOptions: TIMEZONE_STRING, selectedOptionIndex: settings.timezone ?? 0),
                SlidingFormPage.getSelect(withTitle: "对方的时区", desc: nil, selectOptions: TIMEZONE_STRING, selectedOptionIndex: settings.partnerTimezone ?? 0),
        ]) { results in
            settings.nickname = results[0] as! String
            settings.partnerNickname = results[1] as! String
            settings.code = results[2] as! String
            settings.partnerCode = results[3] as! String
            settings.timezone = (results[4] as! [Any])[0] as! Int
            settings.partnerTimezone = (results[5] as! [Any])[0] as! Int
            
            if UserData.sharedInstance.updateUserSettings(withUserSettings: settings) {
                Helpers.sharedInstance.toast(withString: "Success!")
            } else {
                Helpers.sharedInstance.toast(withString: "Failed!")
            }
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
            cell.configureCell(withText: "暂时没有闹钟")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if tabledata.count > 0 {
            let edit = UITableViewRowAction(style: .normal, title: "编辑") { (editAction, curIndexPath) in
                let vc = NewAlarmClockViewController.vc(withElement: self.tabledata[indexPath.row], index: indexPath.row, saveCallback: {
                })
                self.present(vc, animated: true, completion: nil)
            }
            edit.backgroundColor = SLIDER_BG_DARK
            
            let delete = UITableViewRowAction(style: .destructive, title: "删除") { (deleteAction, curIndexPath) in
                self.tabledata.remove(at: curIndexPath.row)
                
                self.saveData()
            }
            delete.backgroundColor = SLIDER_BLOCK
            
            return [delete, edit]
        } else {
            return []
        }
    }
}
