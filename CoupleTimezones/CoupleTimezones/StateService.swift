//
//  NetworkService.swift
//  CoupleTimezones
//
//  Created by Ant on 16/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation
import Firebase

class StateService: NSObject {
    static let shared = StateService()
    
    var isConnected = true {
        didSet {
            if oldValue == false && isConnected && isMatched {
                if UserService.shared.get()?.canUpload == true {
                    AlarmClockService.shared.upload()
                }
            }
        }
    }
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
}
