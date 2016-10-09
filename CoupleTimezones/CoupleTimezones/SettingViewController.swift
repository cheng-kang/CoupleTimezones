//
//  SettingStepByStepViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/7.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    let settings = UserData.sharedInstance.getUserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.startBtn.layer.borderWidth = 2
//        self.startBtn.layer.borderColor = SLIDER_BG_DARK.cgColor
        
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
        let vc = SlidingFormViewController.vc(withStoryboardName: "Main", bundle: nil, identifier: "SlidingFormViewController", andFormTitle: NSLocalizedString("Settings", comment: "SlidingForm"), pages: [
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your nickname.", comment: "SlidingForm"), defaultValue: settings.nickname),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Nickname", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter your partner's nickname.", comment: "SlidingForm"), defaultValue: settings.partnerNickname),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Your Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please enter a special code to identify yourself.\nFormat:\n4 or more characters, consisting only letters and numbers.\nUsage: When the two codes (your code and your partner's code) match with another pair of codes set by another user, your accounts are matched. Matched users will share their alarm clocks.", comment: "SlidingForm"), defaultValue: settings.code),
            SlidingFormPage.getInput(withTitle: NSLocalizedString("Partner's Code", comment: "SlidingForm"), isRequired: true, desc: NSLocalizedString("Please ask your partner for his/her Code.", comment: "SlidingForm"), defaultValue: settings.partnerCode),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: TIMEZONE_NAME_LOCALIZED, selectedOptionIndex: settings.timezone ?? 0),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: TIMEZONE_NAME_LOCALIZED, selectedOptionIndex: settings.partnerTimezone ?? 0),
            ]) { results in
                self.settings.nickname = results[0] as! String
                self.settings.partnerNickname = results[1] as! String
                self.settings.code = results[2] as! String
                self.settings.partnerCode = results[3] as! String
                self.settings.timezone = (results[4] as! [Any])[0] as! Int
                self.settings.partnerTimezone = (results[5] as! [Any])[0] as! Int
                
                if UserData.sharedInstance.updateUserSettings(withUserSettings: self.settings) {
                    Helpers.sharedInstance.toast(withString: "Success!")
                } else {
                    Helpers.sharedInstance.toast(withString: "Failed!")
                    return
                }
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
