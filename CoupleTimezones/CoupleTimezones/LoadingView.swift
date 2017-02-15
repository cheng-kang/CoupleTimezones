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
    
    func initView() {
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        self.addSubview(ai)
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        ai.startAnimating()
    
    }

}
