//
//  NetworkService.swift
//  CoupleTimezones
//
//  Created by Ant on 16/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation
import FirebaseDatabase

class StateService: NSObject {
    static let shared = StateService()
    
    var isConnected = true
    var isMatched = false {
        didSet {
            if oldValue != isMatched {
                // Tell AlarmClockViewController to refresh alarm clocks
                NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshTable"), object: nil)
            }
            
            if isMatched {
                FIRDatabase.database().reference().child("users").child(UserService.shared.get()!.partnerCode!).child("topMessage").observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? String {
                            self.topMessage = value
                    }
                })
            }
        }
    }
    var isPartnerCodeChanged = false
    var topMessage = "" {
        didSet {
            if topMessage != "" {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldUpdateTopMsg"), object: nil)
            }
        }
    }
    var isThemeChanged = false {
        didSet {
            if isThemeChanged {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldUpdateTheme"), object: nil)
                isThemeChanged = false
            }
        }
    }
    var canUpload: Bool? {
        didSet {
            transferData()
        }
    }
    var canDownload: Bool? {
        didSet {
            transferData()
        }
    }
    
    func transferData() {
        if isConnected && isMatched {
            if canDownload == true && canUpload == true {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldShowBtns"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldHideBtns"), object: nil)
            }
            if canDownload == true && canUpload == false {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldDownload"), object: nil)
                AlarmClockService.shared.download()
            }
            if canDownload == false && canUpload == true {
                NotificationCenter.default.post(name: NSNotification.Name("ShouldUpload"), object: nil)
                AlarmClockService.shared.upload()
            }
        }
    }
    
    var SetWidgetVC: SlidingFormViewController?
}
