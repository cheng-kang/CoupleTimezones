//
//  NewAlarmClockViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import Firebase

class NewAlarmClockViewController: UIViewController {
    
    
    @IBOutlet weak var bannerBiew: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableview: UITableView!
    
    var data: AlarmClock!
    var isNew = true
    var dataIndex = 0
    
    var settings = [NSLocalizedString("Repetance", comment: "AlarmClock"), NSLocalizedString("Tag", comment: "AlarmClock")]
    
    var textForRepeat: String {
        var count = 0
        var weekendCount = 0
        
        let selection = data.days
        let dayText = [NSLocalizedString("Mon", comment: "AlarmClock"), NSLocalizedString("Tue", comment: "AlarmClock"), NSLocalizedString("Wed", comment: "AlarmClock"), NSLocalizedString("Thu", comment: "AlarmClock"), NSLocalizedString("Fri", comment: "AlarmClock"), NSLocalizedString("Sat", comment: "AlarmClock"), NSLocalizedString("Sun", comment: "AlarmClock")]
        var selectionText = ""
        for i in 0..<7 {
            if selection[i] {
                count += 1
                if i > 4 {
                    weekendCount += 1
                }
                
                if count == 1 {
                    selectionText = NSLocalizedString("Every ", comment: "AlarmClock")+dayText[i]
                } else {
                    selectionText += NSLocalizedString(", ", comment: "AlarmClock")+dayText[i]
                }
            }
        }
        
        if count == 7 {
            return NSLocalizedString("Everyday", comment: "AlarmClock")
        } else if count == 5 && weekendCount == 0 {
            return NSLocalizedString("Weekday", comment: "AlarmClock")
        } else if count == 2 && weekendCount == 2 {
            return NSLocalizedString("Weekend", comment: "AlarmClock")
        } else if count == 0 {
            return NSLocalizedString("Never", comment: "AlarmClock")
        } else {
            return selectionText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.tableFooterView = UIView()
        
        self.datePicker.setValue(ThemeService.shared.text_dark, forKeyPath: "textColor")
        
        // Init theme color
        self.bannerBiew.backgroundColor = ThemeService.shared.bg_dark
        self.cancelBtn.tintColor = ThemeService.shared.text_light
        self.saveBtn.tintColor = ThemeService.shared.text_light
        self.titleLbl.textColor = ThemeService.shared.text_light
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        if !isNew {
            self.datePicker.date = df.date(from: data.time!)!
        } else {
            // set the init time to the time at partner's timezone
            let date = Helpers.sharedInstance.getDateAtTimezone(UserService.shared.get()!.partnerTimeZone!)
            self.datePicker.date = date
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func vc(with element: AlarmClock? = nil) -> NewAlarmClockViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewAlarmClockViewController") as! NewAlarmClockViewController
        if element != nil {
            vc.isNew = false
            vc.data = element!
        } else {
            // Init new AlarmClock
            let data = AlarmClockService.shared.new()
            data.id = FIRDatabase.database().reference().childByAutoId().key
            data.timeZone = UserService.shared.get()?.partnerTimeZone!
            data.tag = String(format: NSLocalizedString("Remind %@", comment: "AlarmClock"), UserService.shared.get()?.partnerNickname ?? "Darling")
        
            data.isActive = true
            data.days = [false, false, false, false, false, false, false]
            data.isShowingPartnerText = true
            
            data.time = "00:00"
            data.period = NSLocalizedString("AM", comment: "上午")
            
            vc.data = data
        }
        return vc
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        if isNew {
            AlarmClockService.shared.delete(data)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        data.period = Helpers.sharedInstance.getDatetimeText(fromDate: self.datePicker.date, withFormat: "a")
        data.time = Helpers.sharedInstance.getDatetimeText(fromDate: self.datePicker.date, withFormat: "HH:mm")
        
        // Sava data
        AlarmClockService.shared.saveAndUploadSingle(data)
        // Refresh table on AlarmClock page
        NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension NewAlarmClockViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.font = UIFont(name: "FZYanSongS-R-GB", size: 17)
        cell.textLabel?.textColor = ThemeService.shared.text_dark
        cell.detailTextLabel?.font = UIFont(name: "FZYanSongS-R-GB", size: 14)
        cell.detailTextLabel?.textColor = ThemeService.shared.text_dark
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = self.settings[indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = textForRepeat
        } else if indexPath.row == 1 {
            cell.detailTextLabel?.text = data.tag
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = SelectRepeatDayViewController.vc(withSelectionList: self.data.days,savaCallback: { (selectionList) in
                self.data.days = selectionList
                self.tableview.reloadData()
            })
            self.present(vc, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let vc = EditTagViewController.vc(withTag: self.data.tag!, editTagCallback: { (tag) in
                self.data.tag = tag
                self.tableview.reloadData()
            })
            self.present(vc, animated: true, completion: nil)
        }
    }
}
