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
