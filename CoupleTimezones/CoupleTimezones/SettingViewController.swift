//
//  SettingStepByStepViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/7.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    let settings = UserData.sharedInstance.getUserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserDefaults.standard.removeObject(forKey: "AlarmClock")
//        UserDefaults.standard.removeObject(forKey: "UserSettings")
//        UserDefaults.standard.synchronize()
        
        self.startBtn.setTitleColor(TEXT_LIGHT, for: .normal)
        self.startBtn.setTitleColor(TEXT_LIGHT_HIGHLIGHTED, for: .highlighted)
        
        if UserData.sharedInstance.isUserSettingCompleted {
            self.startBtn.setTitle(NSLocalizedString("Start", comment: "开始使用"), for: .normal)
        } else {
            self.startBtn.setTitle(NSLocalizedString("Setting", comment: "初始化设置"), for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingViewController.handleUserSettingDataSynchronized), name: NSNotification.Name(rawValue: "UserSettingDataSynchronized"), object: nil)
    }
    
    func handleUserSettingDataSynchronized() {
        self.startBtn.setTitle(NSLocalizedString("Setting", comment: "初始化设置"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        SlidingFormPageConfig.sharedInstance.customFontName = "FZYanSongS-R-GB"
        SlidingFormPageConfig.sharedInstance.customFontName = "FZMingShangTis-R-GB"
        
        if UserData.sharedInstance.isUserSettingCompleted {
            self.presentAlarmClockVC()
        }
    }
    
    func presentSettingVC() {
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
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.timezone) ),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.partnerTimezone)),
            ]) { results in
                self.settings.nickname = results[0] as! String
                self.settings.partnerNickname = results[1] as! String
                self.settings.code = results[2] as! String
                self.settings.partnerCode = results[3] as! String
                self.settings.timezone = AVAILABLE_TIME_ZONE_LIST[(results[4] as! [Any])[0] as! Int]
                self.settings.partnerTimezone = AVAILABLE_TIME_ZONE_LIST[(results[5] as! [Any])[0] as! Int]
                
                UserData.sharedInstance.updateUserSettings(withUserSettings: self.settings)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentAlarmClockVC() {
        let vc = AlarmClockViewController.vc()
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func startBtnClick(_ sender: UIButton) {
        if UserData.sharedInstance.isUserSettingCompleted {
            self.presentAlarmClockVC()
        } else {
            self.presentSettingVC()
        }
    }
    
}
