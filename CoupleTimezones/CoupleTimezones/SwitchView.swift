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
    
    let borderColor: UIColor = UIColor(red: 93/255, green: 87/255, blue: 107/255, alpha: 1)
    let bgColor: UIColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
    let bgColorActive: UIColor = UIColor(red: 93/255, green: 87/255, blue: 107/255, alpha: 1)
    let buttonColor: UIColor = UIColor(red: 68/255, green: 64/255, blue: 78/255, alpha: 1)
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(SwitchView.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    deinit {
        // remove gesture recognizers
        self.gestureRecognizers?.forEach({ (gr) in
            self.removeGestureRecognizer(gr)
        })
    }
    
    func initSwitch(withIsActive isActive: Bool) {
        if self.isActive != isActive {
            self.toggleSwitch(animated: false)
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.toggleSwitch()
    }
    
    // if animated == true, toggleSwithCallback will be invoked
    func toggleSwitch(animated: Bool = true) {
        self.isActive = !self.isActive
        
        let newCenter: CGPoint = CGPoint(x: self.isActive ? width/4*3 + borderWidth : width/4 + borderWidth, y: switchButtonView.center.y)
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: { 
                self.switchButtonView.center = newCenter
            })
            self.toggleSwitchCallback?(self.isActive)
        } else {
            self.switchButtonView.center = newCenter
        }
    }

}
