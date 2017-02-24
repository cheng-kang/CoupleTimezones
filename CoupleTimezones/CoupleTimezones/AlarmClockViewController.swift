//
//  AlarmClockViewController
//  CoupleTimezones
//
//  Created by Ant on 16/10/5.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AlarmClockViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
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
    let topMsgView = UILabel()
    var currentUser: User?
    var partnerCodeObserverHandle:UInt?
    
    var tabledata = [AlarmClock]()
    
    var timer: Timer?
    var timerCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentUser = UserService.shared.get()
        // Init canUpload state
        StateService.shared.canUpload = currentUser?.canUpload
        
        self.reloadData()
        
        // Init tableview
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = UIView()
        
        // Init top message view
        if StateService.shared.topMessage == "" {
            if currentUser!.relationShipLengthText == "" {
                topMsgView.text = ""
            } else {
                topMsgView.text = String(format: NSLocalizedString("❤️ Together for %@ ❤️", comment: "❤️ 已经在一起 %@ ❤️"), arguments: [currentUser!.relationShipLengthText])
            }
        } else {
            topMsgView.text = StateService.shared.topMessage
        }
        topMsgView.minimumScaleFactor = 0.5
        topMsgView.adjustsFontSizeToFitWidth = true
        topMsgView.lineBreakMode = .byTruncatingTail
        topMsgView.textAlignment = .center
        
        topMsgView.font = UIFont(name: "FZYanSongS-R-GB", size: 16)
        topMsgView.frame = CGRect(x: 10, y: -60, width: self.view.frame.width-20, height: 60)
        self.tableview.addSubview(topMsgView)
        
        loadingView.initView()
        
        // Init upload/download btns
        self.uploadBtn.alpha = 0
        self.downloadBtn.alpha = 0
        let uploadImage = UIImage(named: "Upload")?.withRenderingMode(.alwaysTemplate)
        let downloadImage = UIImage(named: "Download")?.withRenderingMode(.alwaysTemplate)
        self.uploadBtn.setImage(uploadImage, for: .normal)
        self.downloadBtn.setImage(downloadImage, for: .normal)
        
        // Check if user can download
        FIRDatabase.database().reference().child("canDownload").child(self.currentUser!.code!).observe(.value, with: { (snapshot) in
            StateService.shared.canDownload = snapshot.exists()
        })
        
        // Set check: check if user can upload
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
                StateService.shared.isMatchedStateFetched = true
                if partnerCode == self.currentUser?.code {
                    StateService.shared.isMatched = true
                } else {
                    StateService.shared.isMatched = false
                }
            })
        
        // Init theme color
        self.updateTheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.showLoadingView), name: NSNotification.Name("ActivityStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.hideLoadingView), name: NSNotification.Name("ActivityDone"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.reloadData), name: NSNotification.Name("ShouldRefreshAlarmClocks"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.reloadTable), name: NSNotification.Name("ShouldRefreshTable"), object: nil)
        
        // Upload/Download Btns
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.showBtns), name: NSNotification.Name("ShouldShowBtns"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.hideBtns), name: NSNotification.Name("ShouldHideBtns"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.updateTopMsg), name: NSNotification.Name("ShouldUpdateTopMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.updateTheme), name: NSNotification.Name("ShouldUpdateTheme"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmClockViewController.presentSetWidgetVC), name: NSNotification.Name("ShouldPresentSetWidgetVC"), object: nil)
    }
    
    func updateTheme() {
        SlidingFormPageConfig.sharedInstance.bgColor = ThemeService.shared.page_element_dark
        SlidingFormPageConfig.sharedInstance.textColor = ThemeService.shared.text_light
        SlidingFormPageConfig.sharedInstance.textColorHighlighted = ThemeService.shared.text_light_highlighted
        SlidingFormPageConfig.sharedInstance.descColor = ThemeService.shared.text_grey_hightlighted
        SlidingFormPageConfig.sharedInstance.warningColor = ThemeService.shared.text_warning
        
        self.bannerView.backgroundColor = ThemeService.shared.bg_dark
        self.navLocLbl.textColor = ThemeService.shared.text_light
        self.navTimeLbl.textColor = ThemeService.shared.text_light
        self.navPeriodLbl.textColor = ThemeService.shared.text_light
        self.addBtn.tintColor = ThemeService.shared.text_light
        self.menuBtn.tintColor = ThemeService.shared.text_light
        
        self.topMsgView.textColor = ThemeService.shared.text_dark
        self.uploadBtn.tintColor = ThemeService.shared.page_element_dark
        self.downloadBtn.tintColor = ThemeService.shared.page_element_dark
        
        self.tableview.reloadData()
    }
    
    func updateTopMsg() {
        self.topMsgView.text = StateService.shared.topMessage
    }
    
    func showLoadingView() {
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func clearTable() {
        // When downloading data, clear table
        self.tabledata = []
        self.tableview.reloadData()
    }
    
    func hideBtns() {
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadBtn.alpha = 0
            self.downloadBtn.alpha = 0
        })
    }
    
    // Show upload/download btns
    func showBtns() {
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadBtn.alpha = 1
            self.downloadBtn.alpha = 1
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh user data after setting finished
        currentUser = UserService.shared.get()
        
        // If partnerCode changed, reset check
        if StateService.shared.isPartnerCodeChanged {
            if let handle = partnerCodeObserverHandle {
                FIRDatabase.database().reference().removeObserver(withHandle: handle)
            }
            StateService.shared.isMatchedStateFetched = false
            StateService.shared.isMatched = false
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
                    StateService.shared.isMatchedStateFetched = true
                    if partnerCode == self.currentUser?.code {
                        StateService.shared.isMatched = true
                    } else {
                        StateService.shared.isMatched = false
                    }
                })
            
            // Rest isPartnerCodeChanged
            StateService.shared.isPartnerCodeChanged = false
        }
        
        updateTimeLbl()
        // start timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AlarmClockViewController.updateTimeLbl), userInfo: nil, repeats: true)
        timer!.fire()
        
        // Update topMessage
        if StateService.shared.topMessage == "" {
            if currentUser!.relationShipLengthText == "" {
                topMsgView.text = ""
            } else {
                topMsgView.text = String(format: NSLocalizedString("❤️ Together for %@ ❤️", comment: "❤️ 已经在一起 %@ ❤️"), arguments: [currentUser!.relationShipLengthText])
            }
        } else {
            topMsgView.text = StateService.shared.topMessage
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presentSetWidgetVC()
    }
    
    func presentSetWidgetVC() {
        if let vc = StateService.shared.SetWidgetVC {
            self.present(vc, animated: true, completion: {
                StateService.shared.SetWidgetVC = nil
            })
        }
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ActivityStart"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ActivityDone"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldRefreshAlarmClocks"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldRefreshTable"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldHideBtns"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldShowBtns"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldUpdateTopMsg"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShouldUpdateTheme"), object: nil)
    }
    
    func updateTimeLbl() {
        self.timerCount += 1
        
        let user = UserService.shared.get()!
        let date = Helpers.sharedInstance.getDateAtTimezone(user.partnerTimeZone!)
        
        let dif = Helpers.sharedInstance.getTimeIntervalBetweenLocalAndTimeZone(user.partnerTimeZone!)
        let partnerDate = Date().addingTimeInterval(-dif)
        let isYesterday = Calendar.current.isDateInYesterday(partnerDate)
        let isTommorrow = Calendar.current.isDateInTomorrow(partnerDate)
        let dayDiffString = isYesterday ? NSLocalizedString("YDA ", comment: "昨天") : isTommorrow ? NSLocalizedString("TMW ", comment: "明天") : ""
        
        self.navLocLbl.text = TimeZone(identifier: user.partnerTimeZone!)!.localizedName(for: .shortGeneric, locale: Locale.current)
        self.navTimeLbl.text = (self.timerCount % 2 ) == 0 ? Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH:mm") : Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "HH mm")
        self.navPeriodLbl.text = dayDiffString + Helpers.sharedInstance.getDatetimeText(fromDate: date, withFormat: "a")
    }
    
    func reloadTable() {
        self.tableview.reloadData()
    }
    func reloadData() {
        self.tabledata = AlarmClockService.shared.get()
        self.tableview.reloadData()
    }
    
    func deleteData(atIndex idx: Int) {
        // Pop out the item
        let item = self.tabledata.remove(at: StateService.shared.isMatched ? idx : idx - 1)
        // Refresh table before deleting the record from database
        // So that it won't occur the case that
        // the cell to be deleted display on screen with no data
        self.tableview.reloadData()
        AlarmClockService.shared.deleteAndUploadSingle(item)
    }

    @IBAction func addBtnClick(_ sender: UIButton) {
        let vc = NewAlarmClockViewController.vc()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnClick(_ sender: UIButton) {
        let settings = UserService.shared.get()!
        
        SlidingFormPageConfig.sharedInstance.customFontName = "FZYanSongS-R-GB"
        var pages = [
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your nickname.", comment: "SlidingForm"), defaultValue: settings.nickname, errorMsg: "长度至少一位"),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your partner's nickname.", comment: "SlidingForm"), defaultValue: settings.partnerNickname, errorMsg: "长度至少一位"),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter a special code to identify yourself.\nFormat:\n4 or more characters, consisting only letters and numbers.\nUsage: When the two codes (your code and your partner's code) match with another pair of codes set by another user, your accounts are matched. Matched users will share their alarm clocks.", comment: "SlidingForm"), defaultValue: settings.code, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成") { inputValue, errorMsgLabel in
                FIRDatabase.database().reference().child("users").child(inputValue).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() && inputValue != self.currentUser!.code {
                        errorMsgLabel.text = NSLocalizedString("Code is used by someone else.", comment: "神秘代码已被占用。")
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentPageFinished"), object: nil)
                        errorMsgLabel.text = ""
                    }
                })
                
            },
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please ask your partner for his/her Code.", comment: "SlidingForm"), defaultValue: settings.partnerCode, inputRule: "[A-Za-z0-9]{4,}", errorMsg: "长度至少四位，由字母和数字组成"),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: ConstantService.shared.timeZoneNames, selectedOptionIndex: ConstantService.shared.index(of: settings.timeZone) ),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: ConstantService.shared.timeZoneNames, selectedOptionIndex: ConstantService.shared.index(of: settings.partnerTimeZone)),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Theme", comment: "SlidingForm"), desc: nil, selectOptions: ThemeService.shared.themeStrs, selectedOptionIndex: ThemeService.shared.seletedThemeIndex),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Email", comment: "SlidingForm"), desc: NSLocalizedString("Enter your email for better service.", comment: "SlidingForm"), defaultValue: settings.email),
            ]
        if StateService.shared.isMatched {
            pages.append(contentsOf: [
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Relation Start Date", comment: "SlidingForm"), desc: NSLocalizedString("Set up your relation start date, in the format of this example: 2016-05-30.\nIf your partner leaves Hidden Message empty, a message about how long you've been together will be shown at your list top.\nLike: ❤️ Together for 8 months 18 days ❤️", comment: "SlidingForm"), defaultValue: settings.startDate),
                SlidingFormPage.getInput(withTitle: NSLocalizedString("Hidden Message", comment: "SlidingForm"), desc: NSLocalizedString("Set up a hidden message that will should on top of the alarm clock list on your partner's device.", comment: "SlidingForm"), defaultValue: settings.topMessage),
                ])
        }
        let vc = SlidingFormViewController.vc(
            withStoryboardName: "Main",
            bundle: nil,
            identifier: "SlidingFormViewController",
            andFormTitle: NSLocalizedString("Settings",comment: "SlidingForm"),
            pages: pages) { results in
                let user = UserService.shared.get()!
                
                // Check if partnerCode is changed
                let oldCode = user.code!
                let oldPartnerCode = user.partnerCode!
                let oldPairCode = oldCode < oldPartnerCode ? oldCode+"-"+oldPartnerCode : oldPartnerCode+"-"+oldCode
                let isCodeChanged = results[2] as? String != oldCode
                let isPartnerCodeChanged = results[3] as? String != oldPartnerCode
                let isThemeChanged = ((results[6] as! [Any])[0] as! Int) != ThemeService.shared.seletedThemeIndex
                
                user.nickname = results[0] as! String
                user.partnerNickname = results[1] as! String
                user.code = results[2] as! String
                user.partnerCode = results[3] as! String
                user.timeZone = ConstantService.shared.timeZones[(results[4] as! [Any])[0] as! Int]
                user.partnerTimeZone = ConstantService.shared.timeZones[(results[5] as! [Any])[0] as! Int]
                user.theme = ThemeService.shared.themeStrs[(results[6] as! [Any])[0] as! Int]
                user.email = results[7] as! String
                
                var updates = [String:Any]()
                updates["users/\(user.code!)/email"] = user.email!
                if results.count > 8 {
                    user.startDate = results[8] as? String
                    user.topMessage = results[9] as? String
                    
                    updates["users/\(user.code!)/startDate"] = user.startDate!
                    updates["users/\(user.code!)/topMessage"] = user.topMessage!
                }
                if isPartnerCodeChanged {
                    StateService.shared.isPartnerCodeChanged = isPartnerCodeChanged // 这一行好像没有用 ：）
                    updates["/users/\(user.code!)/partnerCode"] = user.partnerCode!
                }
                if isPartnerCodeChanged || isCodeChanged {
                    updates["/alarms/\(oldPairCode)"] = NSNull()
                }
                
                if StateService.shared.isConnected {
                    FIRDatabase.database().reference().updateChildValues(updates, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            UserService.shared.save()
                            if isPartnerCodeChanged {
                                StateService.shared.isPartnerCodeChanged = true
                            }
                            if isThemeChanged {
                                StateService.shared.isThemeChanged = true
                            }
                            // Pop up alert: Update Success.
                        } else {
                            // Pop up alert: Update Fail.
                        }
                    })
                } else {
                    self.toast(NSLocalizedString("Unable to save data, please check your network connection.", comment: "保存失败，请检查网络连接。"), with: ThemeService.shared.bg_dark)
                }
                
        }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func uploadBtnOnPress(_ sender: UIButton) {
        AlarmClockService.shared.upload()
    }
    
    @IBAction func downloadBtnOnPress(_ sender: UIButton) {
        AlarmClockService.shared.download()
    }
}

extension AlarmClockViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count == 0 ? 1 : StateService.shared.isMatched == false ? tabledata.count + 1 : tabledata.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabledata.count > 0 {
            if StateService.shared.isMatched == false {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AttentionCell") as! AttentionCell
                    cell.msgLbl.text = StateService.shared.isMatchedStateFetched ? NSLocalizedString("Partner not found", comment: "没有找到你的对象") : NSLocalizedString("Matching partner...", comment: "正在匹配你的对象……")
                    
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
                let vc = NewAlarmClockViewController.vc(with: self.tabledata[indexPath.row])
                self.present(vc, animated: true, completion: nil)
            }
            edit.backgroundColor = ThemeService.shared.page_element_dark
            
            let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "AlarmClock")) { (deleteAction, curIndexPath) in
                
                self.deleteData(atIndex: indexPath.row)
            }
            delete.backgroundColor = ThemeService.shared.page_element_block
            
            return [delete, edit]
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabledata.count > 0 && StateService.shared.isMatched == false && indexPath.row == 0 {
            return 34
        }
        return 90
    }
}
