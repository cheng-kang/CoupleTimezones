//
//  SelectRepeatDayViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class SelectRepeatDayViewController: UIViewController {

    @IBOutlet weak var ratioPanelView: UIView!
    var allBtn = RatioView()
    var weekdayBtn = RatioView()
    var weekendBtn = RatioView()
    @IBOutlet weak var tableview: UITableView!
    
    var savaCallback: ((_ selection: [Bool])->())?
    
    let daysText = [NSLocalizedString("Sunday", comment: "Repetance"), NSLocalizedString("Monday", comment: "Repetance"), NSLocalizedString("Tuesday", comment: "Repetance"), NSLocalizedString("Wednesday", comment: "Repetance"), NSLocalizedString("Thursday", comment: "Repetance"), NSLocalizedString("Friday", comment: "Repetance"), NSLocalizedString("Saturday", comment: "Repetance")]
    var isInitSelection = true
    var selection = [false, false, false, false, false, false, false] {
        didSet {
            var count = 0
            var weekendCount = 0
            for i in 0..<7 {
                if selection[i] {
                    count += 1
                    if i == 0 || i == 6 {
                        weekendCount += 1
                    }
                }
            }
            
            if count == 7 {
                allBtn.select()
                weekdayBtn.deselect()
                weekendBtn.deselect()
            } else if count == 5 && weekendCount == 0 {
                allBtn.deselect()
                weekdayBtn.select()
                weekendBtn.deselect()
            } else if count == 2 && weekendCount == 2 {
                allBtn.deselect()
                weekdayBtn.deselect()
                weekendBtn.select()
            } else {
                allBtn.deselect()
                weekdayBtn.deselect()
                weekendBtn.deselect()
            }
            
            if isInitSelection {
                isInitSelection = false
            } else {
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
        
        self.ratioPanelView.addSubview(allBtn)
        self.ratioPanelView.addSubview(weekdayBtn)
        self.ratioPanelView.addSubview(weekendBtn)
        // init ratio views
        self.allBtn.initRatioView(withIsSelected: false, text: NSLocalizedString("Everyday", comment: "Repetance"), centerPoint: CGPoint(x: self.view.frame.width / 4, y: 30)) { isSelected in
            if isSelected {
                self.selection = [true, true, true, true, true, true, true]
            } else {
                if !self.weekendBtn.isSeleted && !self.weekdayBtn.isSeleted {
                    self.selection = [false, false, false, false, false, false, false]
                }
            }
        }
        self.weekdayBtn.initRatioView(withIsSelected: false, text: NSLocalizedString("Weekday", comment: "Repetance"), centerPoint: CGPoint(x: self.view.frame.width / 2, y: 30)) { isSelected in
            if isSelected {
                self.selection = [false, true, true, true, true, true, false]
            } else {
                if !self.weekendBtn.isSeleted && !self.allBtn.isSeleted {
                    self.selection = [false, false, false, false, false, false, false]
                }
            }
        }
            self.weekendBtn.initRatioView(withIsSelected: false, text: NSLocalizedString("Weekend", comment: "Repetance"), centerPoint: CGPoint(x: self.view.frame.width / 4 * 3, y: 30)) { isSelected in
                if isSelected {
                    self.selection = [true, false, false, false, false, false, true]
                } else {
                    if !self.allBtn.isSeleted && !self.weekdayBtn.isSeleted {
                        self.selection = [false, false, false, false, false, false, false]
                    }
                }
        }
        
        // reload selection data to init btns' UI
        var copy = [Bool]()
        copy.append(contentsOf: self.selection)
        self.selection = copy
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class func vc(withSelectionList selection: [Bool], savaCallback: ((_ selection: [Bool])->())?) -> SelectRepeatDayViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectRepeatDayViewController") as! SelectRepeatDayViewController
        vc.selection = selection
        vc.savaCallback = savaCallback
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

    @IBAction func backBtnClcik(_ sender: UIButton) {
        self.savaCallback?(self.selection)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectRepeatDayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayInWeekCell") as! DayInWeekCell
        cell.configureCell(withText: daysText[indexPath.row], isActive: selection[indexPath.row] ) { isActive in
            self.selection[indexPath.row] = isActive
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        (tableView.cellForRow(at: indexPath) as! DayInWeekCell).switchBtn.toggleSwitch()
    }
}
