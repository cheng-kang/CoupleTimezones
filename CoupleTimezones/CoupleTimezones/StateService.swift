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
        }
    }
    var isPartnerCodeChanged = false
}
