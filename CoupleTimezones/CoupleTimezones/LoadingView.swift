//
//  LoadingView.swift
//  CoupleTimezones
//
//  Created by Ant on 15/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var ai = UIActivityIndicatorView()
    var hl = UIImageView()
    var hm = UIImageView()
    var hr = UIImageView()
    var hlsp: CGPoint!
    var hmsp: CGPoint!
    var hrsp: CGPoint!
    var hlep: CGPoint!
    var hmep: CGPoint!
    var hrep: CGPoint!
    var tl: Timer?
    var tm: Timer?
    var tr: Timer?
    
    func initView() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        ai.activityIndicatorViewStyle = .white
        ai.hidesWhenStopped = true
        ai.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        ai.startAnimating()
        self.addSubview(ai)
        
        
        hl.frame.size = CGSize(width: 13, height: 13)
        hm.frame.size = CGSize(width: 13, height: 13)
        hr.frame.size = CGSize(width: 13, height: 13)
        hl.image = UIImage(named: "heart-left")
        hm.image = UIImage(named: "heart-right")
        hr.image = UIImage(named: "heart-right")
        
        let cx = self.center.x // centerX
        let cy = self.center.y // centerY
        
        hlsp = CGPoint(x: cx - 10, y: cy + 20)
        hmsp = CGPoint(x: cx, y: cy)
        hrsp = CGPoint(x: cx + 15, y: cy + 10)
        hlep = CGPoint(x: cx - 10, y: cy - 60)
        hmep = CGPoint(x: cx, y: cy - 90)
        hrep = CGPoint(x: cx + 15, y: cy - 75)
        
        self.addSubview(hl)
        self.addSubview(hm)
        self.addSubview(hr)
        
    
        startAnimation()
    }
    
    func startAnimation() {
        hl.center = hlsp
        hm.center = hmsp
        hr.center = hrsp
        hl.alpha = 1
        hm.alpha = 1
        hr.alpha = 1
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
            self.hm.center = self.hmep
            self.hm.alpha = 0
        }, completion: nil)
        UIView.animate(withDuration: 0.85, delay: 0.15, options: [.curveEaseInOut], animations: {
            self.hr.center = self.hrep
            self.hr.alpha = 0
            
        }, completion: nil)
        UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseInOut], animations: {
            self.hl.center = self.hlep
            self.hl.alpha = 0
            
        }, completion: nil)
        tm = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true) { (_) in
            self.hm.center = self.hmsp
            self.hm.alpha = 1
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
                self.hm.center = self.hmep
                self.hm.alpha = 0
                
            }, completion: nil)
        }
        tr = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true) { (_) in
            self.hr.center = self.hrsp
            self.hr.alpha = 1
            UIView.animate(withDuration: 0.85, delay: 0.15, options: [.curveEaseInOut], animations: {
                self.hr.center = self.hrep
                self.hr.alpha = 0
                
            }, completion: nil)
        }
        tl = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true) { (_) in
            self.hl.center = self.hlsp
            self.hl.alpha = 1
            UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseInOut], animations: {
                self.hl.center = self.hlep
                self.hl.alpha = 0
                
            }, completion: nil)
        }
    }
    
    func stopAnimation() {
        tl?.invalidate()
        tm?.invalidate()
        tr?.invalidate()
    }
    
    deinit {
        stopAnimation()
    }

}
