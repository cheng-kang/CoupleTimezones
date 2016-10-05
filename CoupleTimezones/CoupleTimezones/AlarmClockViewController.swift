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
        
        // fake data
        tabledata.append(AlarmClockModel(withId: "a",
                                         period: "上午",
                                         time: "04:40",
                                         location: "洛杉矶",
                                         content: "要去机场了！！！",
                                         isActive: true,
                                         days: [true, true, false, false, true, false, true])
        )
        tabledata.append(AlarmClockModel(withId: "b",
                                         period: "上午",
                                         time: "08:30",
                                         location: "洛杉矶",
                                         content: "宝贝早上没有第一节课，所以晚点叫她",
                                         isActive: true,
                                         days: [true, true, true, true, true, true, true])
        )
        tabledata.append(AlarmClockModel(withId: "c",
                                         period: "上午",
                                         time: "12:30",
                                         location: "洛杉矶",
                                         content: "宝贝要吃饭啦！！！",
                                         isActive: true,
                                         days: [false, false, false, false, true, false, true])
        )
        
        // init tableview
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AlarmClockViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmClockCell") as! AlarmClockCell
        
        cell.configureCell(withAlarmClockData: tabledata[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "编辑") { (editAction, curIndexPath) in
            
        }
        edit.backgroundColor = SLIDER_BG_DARK
        
        let delete = UITableViewRowAction(style: .destructive, title: "删除") { (deleteAction, curIndexPath) in
            self.tabledata.remove(at: curIndexPath.row)
        }
        delete.backgroundColor = SLIDER_BLOCK
        
        return [delete, edit]
    }
}
