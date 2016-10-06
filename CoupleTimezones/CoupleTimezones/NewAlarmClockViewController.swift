//
//  NewAlarmClockViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class NewAlarmClockViewController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableview: UITableView!
    
    var saveCallback: (()->())?
    
    var data = AlarmClockModel(withId: "a", period: "", time: "", location: "", content: "提醒亲爱的", isActive: true, days: [false, false, false, false, false, false, false])
    var isNew = true
    var dataIndex = 0
    
    var settings = ["重复", "标签"]
    
    var textForRepeatance: String {
        var count = 0
        var weekendCount = 0
        
        let selection = data.days
        let dayText = ["日", "一", "二", "三", "四", "五", "六"]
        var selectionText = ""
        for i in 0..<7 {
            if selection![i] {
                count += 1
                if i == 0 || i == 6 {
                    weekendCount += 1
                }
                
                if count == 1 {
                    selectionText = "每周"+dayText[i]
                } else {
                    selectionText += "、"+dayText[i]
                }
            }
        }
        
        if count == 7 {
            return "每天"
        } else if count == 5 && weekendCount == 0 {
            return "工作日"
        } else if count == 2 && weekendCount == 2 {
            return "周末"
        } else if count == 0 {
            return "永不"
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
        
        if !isNew {
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            self.datePicker.date = df.date(from: data.time)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func vc(withElement element: AlarmClockModel? = nil, index: Int = 0, saveCallback: (()->())?) -> NewAlarmClockViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewAlarmClockViewController") as! NewAlarmClockViewController
        if element != nil {
            vc.isNew = false
            vc.data = element!
            vc.dataIndex = index
        }
        vc.saveCallback = saveCallback
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
        data.period = Helpers.sharedInstance.datetimeText(fromDate: self.datePicker.date, withFormat: "a")
        data.time = Helpers.sharedInstance.datetimeText(fromDate: self.datePicker.date, withFormat: "HH:mm")
        
        if isNew {
            data.location = "洛杉矶"
            
            if UserData.sharedInstance.insertAlarmClock(newElement: data) {
                Helpers.sharedInstance.toast(withString: "Success")
            } else {
                Helpers.sharedInstance.toast(withString: "Fail")
            }
        } else {
            if UserData.sharedInstance.updateAlarmClock(atIndex: dataIndex, withElement: data) {
                Helpers.sharedInstance.toast(withString: "Success")
            } else {
                Helpers.sharedInstance.toast(withString: "Fail")
            }
        }
        
        saveCallback?()
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
        
        cell.textLabel?.font = TEXT_FONT(withSize: 17)
        cell.detailTextLabel?.font = TEXT_FONT(withSize: 17)
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = self.settings[indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = textForRepeatance
        } else if indexPath.row == 1 {
            cell.detailTextLabel?.text = data.content
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
            let vc = EditTagViewController.vc(withTag: self.data.content, editTagCallback: { (tag) in
                self.data.content = tag
                self.tableview.reloadData()
            })
            self.present(vc, animated: true, completion: nil)
        }
    }
}
