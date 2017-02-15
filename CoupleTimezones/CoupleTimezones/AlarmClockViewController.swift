//
//  AlarmClockViewController
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import Firebase

class AlarmClockViewController: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var navTimeLbl: UILabel!
    @IBOutlet weak var navLocLbl: UILabel!
    @IBOutlet weak var navPeriodLbl: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet var uploadBtnToRight: NSLayoutConstraint!
    
    @IBOutlet weak var tableview: UITableView!
    let loadingView = LoadingView()
    var currentUser: User?
    var isMatched: Bool? {
        didSet {
            if oldValue != isMatched {
                self.tableview.reloadData()
            }
        }
    }
    var partnerCodeObserverHandle:UInt?
    
    var tabledata = [AlarmClock]()
    
    var timer: Timer?
    var timerCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentUser = UserService.shared.get()
        self.reloadData()
        
        // init tableview
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
        
        loadingView.initView()
        
        self.uploadBtn.alpha = 0
        self.downloadBtn.alpha = 0
        let uploadImage = UIImage(named: "Upload")?.withRenderingMode(.alwaysTemplate)
        let downloadImage = UIImage(named: "Download")?.withRenderingMode(.alwaysTemplate)
        self.uploadBtn.setImage(uploadImage, for: .normal)
        self.downloadBtn.setImage(downloadImage, for: .normal)
        self.uploadBtn.tintColor = SLIDER_BG_DARK
        self.downloadBtn.tintColor = SLIDER_BG_DARK
        
        // Check if user can download
        FIRDatabase.database().reference().child("canDownload").child(currentUser!.code!).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Show downloadBtn
                UIView.animate(withDuration: 0.3, animations: {
                    self.downloadBtn.alpha = 1
                    self.uploadBtnToRight.constant = 46
                })
            } else {
                // Hide downloadBtn
                UIView.animate(withDuration: 0.3, animations: {
                    self.downloadBtn.alpha = 0
                    self.uploadBtnToRight.constant = 8
                })
            }
        })
        
        // Check if user can upload
        partnerCodeObserverHandle = FIRDatabase.database().reference()
            .child("users")
            .child(currentUser!.partnerCode!)
            .child("partnerCode")
            .observe(.value, with: { (snapshot) in
                if snapshot.value as? String == self.currentUser?.code {
                    self.isMatched = true
                    if self.currentUser?.canUpload ?? false {
                        // Show uploadBtn
                        UIView.animate(withDuration: 0.3, animations: {
                            self.uploadBtn.alpha = 1
                        })
                    }
                } else {
                    self.isMatched = false
                    // Hide uploadBtn
                    UIView.animate(withDuration: 0.3, animations: {
                        self.uploadBtn.alpha = 0
                    })
                }
            })
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.clearTable), name: NSNotification.Name("DownloadingAlarmClocks"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.reloadData), name: NSNotification.Name("DownloadedAlarmClocks"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.hideUploadBtn), name: NSNotification.Name("CanUploadFalse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.showUploadBtn), name: NSNotification.Name("CanUploadTrue"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.hideLoadingView), name: NSNotification.Name("ActivityDone"), object: nil)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func clearTable() {
        // When downloading data, clear table
        self.tabledata = []
        self.tableview.reloadData()
    }
    
    func hideUploadBtn() {
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadBtn.alpha = 0
        })
    }
    
    func showUploadBtn() {
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadBtn.alpha = 1
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh user data after setting finished
        currentUser = UserService.shared.get()
        
        if let handle = partnerCodeObserverHandle {
            FIRDatabase.database().reference().removeObserver(withHandle: handle)
            
            // Reset check: check if user can upload
            partnerCodeObserverHandle = FIRDatabase.database().reference()
                .child("users")
                .child(currentUser!.partnerCode!)
                .child("partnerCode")
                .observe(.value, with: { (snapshot) in
                    var partnerCode = ""
                    if let value = snapshot.value as? String {
                        partnerCode = value
                    }
                    if let value = snapshot.value as? Int {
                        partnerCode = value.description
                    }
                    if partnerCode == self.currentUser?.code {
                        self.isMatched = true
                        if self.currentUser?.canUpload ?? false {
                            // Show uploadBtn
                            UIView.animate(withDuration: 0.3, animations: {
                                self.uploadBtn.alpha = 1
                            })
                        }
                    } else {
                        self.isMatched = false
                        // Hide uploadBtn
                        UIView.animate(withDuration: 0.3, animations: {
                            self.uploadBtn.alpha = 0
                        })
                    }
                })
        }
        
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DownloadingAlarmClocks"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DownloadedAlarmClocks"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CanUploadFalse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CanUploadTrue"), object: nil)
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
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter a special code to identify yourself.\nFormat:\n4 or more characters, consisting only letters and numbers.\nUsage: When the two codes (your code and your partner's code) match with another pair of codes set by another user, your accounts are matched. Matched users will share their alarm clocks.", comment: "SlidingForm"), defaultValue: settings.code, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成") { inputValue, errorMsgLabel in
                    FIRDatabase.database().reference().child("users").child(inputValue).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            errorMsgLabel.text = NSLocalizedString("Code is used by someone else.", comment: "神秘代码已被占用。")
                        } else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentPageFinished"), object: nil)
                            errorMsgLabel.text = ""
                        }
                    })
                    
                },
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please ask your partner for his/her Code.", comment: "SlidingForm"), defaultValue: settings.partnerCode, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成"),
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.timeZone!) ),
                SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.partnerTimeZone!)),
                ]) { results in
                    let user = UserService.shared.get()!
                    user.nickname = results[0] as? String
                    user.partnerNickname = results[1] as? String
                    user.code = results[2] as? String
                    user.partnerCode = results[3] as? String
                    user.timeZone = AVAILABLE_TIME_ZONE_LIST[(results[4] as! [Any])[0] as! Int]
                    user.partnerTimeZone = AVAILABLE_TIME_ZONE_LIST[(results[5] as! [Any])[0] as! Int]
                    
                    FIRDatabase.database().reference().child("users").child(user.code!)
                        .updateChildValues([
                            "partnerCode": user.partnerCode!
                        ], withCompletionBlock: { (error, ref) in
                            if error == nil {
                                UserService.shared.save()
                                // Pop up alert: Update Success.
                            } else {
                                // Pop up alert: Update Fail.
                            }
                    })
        }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func uploadBtnOnPress(_ sender: UIButton) {
        self.view.addSubview(loadingView)
        AlarmClockService.shared.upload()
    }
    
    @IBAction func downloadBtnOnPress(_ sender: UIButton) {
        self.view.addSubview(loadingView)
        AlarmClockService.shared.download()
    }
}

extension AlarmClockViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count == 0 ? 1 : isMatched == false ? tabledata.count + 1 : tabledata.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabledata.count > 0 {
            if isMatched == false {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AttentionCell") as! AttentionCell
                    cell.msgLbl.text = NSLocalizedString("Partner not found", comment: "没有找到你的对象")
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmClockCell") as! AlarmClockCell
                    
                    cell.configureCell(with: tabledata[indexPath.row-1])
                    
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmClockCell") as! AlarmClockCell
                
                cell.configureCell(with: tabledata[indexPath.row])
                
                return cell
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabledata.count > 0 && isMatched == false && indexPath.row == 0 {
            return 34
        }
        return 90
    }
}
