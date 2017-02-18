//
//  SwitchView.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class SwitchView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let width: CGFloat = 50
    let height: CGFloat = 25
    let borderWidth: CGFloat = 1
    
    var borderColor: UIColor = ThemeService.shared.page_element_block
    var bgColor: UIColor = ThemeService.shared.page_element_light
    var bgColorActive: UIColor = ThemeService.shared.page_element_dark
    var buttonColor: UIColor = ThemeService.shared.page_element_block
    
    let duration: Double = 0.2
    
    var bgLeftActiveView = UIView()
    var switchButtonView = UIView()
    
    var isActive = false
    var toggleSwitchCallback: ((_ isActive: Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame.size = CGSize(width: width, height: height)
        self.backgroundColor = bgColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        bgLeftActiveView.frame = CGRect(x: borderWidth, y: borderWidth, width: width/2, height: height)
        bgLeftActiveView.backgroundColor = bgColorActive
        self.addSubview(bgLeftActiveView)
        
        switchButtonView.frame = CGRect(x: borderWidth, y: borderWidth, width: width/2, height: height)
        switchButtonView.backgroundColor = buttonColor
        self.addSubview(switchButtonView)
        
        // init tap event by adding tap gesture recognizer to self
        let tap = UITapGestureRecognizer(target: self, action: #selector(SwitchView.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    deinit {
        // remove gesture recognizers
        self.gestureRecognizers?.forEach({ (gr) in
            self.removeGestureRecognizer(gr)
        })
    }
    
    func initSwitch(_ isActive: Bool, animated: Bool = false) {
        self.isActive = isActive
        if self.isActive {
            self.setActive(animated)
        } else {
            self.setInactive(animated)
        }
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.toggleSwitch()
    }
    
    // if animated == true, toggleSwithCallback will be invoked
    func toggleSwitch(_ animated: Bool = true) {
        self.isActive = !self.isActive
        
        let newCenter: CGPoint = CGPoint(x: self.isActive ? width/4*3 + borderWidth : width/4 + borderWidth, y: switchButtonView.center.y)
        
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.switchButtonView.center = newCenter
            })
            self.toggleSwitchCallback?(self.isActive)
        } else {
            self.switchButtonView.center = newCenter
        }
    }
    
    func setActive(_ animated: Bool = true) {
        let newCenter: CGPoint = CGPoint(x: width/4*3 + borderWidth, y: switchButtonView.center.y)
        
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.switchButtonView.center = newCenter
            })
        } else {
            self.switchButtonView.center = newCenter
        }
    }
    
    func setInactive(_ animated: Bool = true) {
        let newCenter: CGPoint = CGPoint(x: width/4 + borderWidth, y: switchButtonView.center.y)
        
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.switchButtonView.center = newCenter
            })
        } else {
            self.switchButtonView.center = newCenter
        }
    }

}
