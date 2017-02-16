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
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startBtn.setTitleColor(TEXT_LIGHT, for: .normal)
        self.startBtn.setTitleColor(TEXT_LIGHT_HIGHLIGHTED, for: .highlighted)
        SlidingFormPageConfig.sharedInstance.customFontName = "FZMingShangTis-R-GB"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserService.shared.get() == nil {
            self.startBtn.setTitle(NSLocalizedString("Setting", comment: "初始化设置"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserService.shared.get() != nil {
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
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Your Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.timezone) ),
            SlidingFormPage.getSelect(withTitle: NSLocalizedString("Partner's Timezone", comment: "SlidingForm"), desc: nil, selectOptions: AVAILABLE_TIME_ZONE_LIST_LOCALIZED, selectedOptionIndex: Helpers.sharedInstance.getTimezoneIndexByIdentifier(settings.partnerTimezone)),
            ]) { results in
                let user = UserService.shared.new()
                user.nickname = results[0] as? String
                user.partnerNickname = results[1] as? String
                user.code = results[2] as? String
                user.partnerCode = results[3] as? String
                user.timeZone = AVAILABLE_TIME_ZONE_LIST[(results[4] as! [Any])[0] as! Int]
                user.partnerTimeZone = AVAILABLE_TIME_ZONE_LIST[(results[5] as! [Any])[0] as! Int]
                
                FIRDatabase.database().reference().child("users").updateChildValues(
                    [
                        user.code!: [
                            "partnerCode": user.partnerCode!
                        ]
                    ], withCompletionBlock: { (error, ref) in
                        if error == nil {
                            UserService.shared.save()
                            // Pop up alert: Set up success.
                        } else {
                            // Pop up alert: Fail to set up.
                        }
                })
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentAlarmClockVC() {
        let vc = AlarmClockViewController.vc()
        self.present(vc, animated: true, completion: nil)
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
        if (currentUser != nil) {
            self.presentAlarmClockVC()
        } else {
            self.presentSettingVC()
        }
    }
    
}
