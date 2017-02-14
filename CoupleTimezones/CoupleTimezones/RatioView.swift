//
//  RatioView.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class RatioView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var height: CGFloat = 20
    var buttonWidth: CGFloat = 14
    var dotWidth: CGFloat = 4
    var textLblAlphaUnselected: CGFloat = 0.7
    var dotViewAlphaUnselected: CGFloat = 0
    
    var buttonBgColor: UIColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
    var buttonBorderColor: UIColor = UIColor(red: 93/255, green: 87/255, blue: 107/255, alpha: 1)
    var dotColor: UIColor = UIColor(red: 68/255, green: 64/255, blue: 78/255, alpha: 1)
    var textColor: UIColor = UIColor(red: 51/255, green: 48/255, blue: 59/255, alpha: 1)
    var textFont: UIFont = UIFont(name: "FZYanSongS-R-GB", size: 20)!
    
    var buttonBgView = UIView()
    var dotView = UIView()
    var textLbl = UILabel()
    
    var text = ""
    
    var isSeleted = false
    var toggleRatioSelectionCallback: ((_ isSelected: Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
    }
    
    func initUI() {
        self.buttonBgView.backgroundColor = buttonBgColor
        self.buttonBgView.layer.borderColor = buttonBorderColor.cgColor
        self.buttonBgView.layer.borderWidth = 2
        self.buttonBgView.layer.cornerRadius = buttonWidth / 2
        self.buttonBgView.frame.size = CGSize(width: buttonWidth, height: buttonWidth)
        self.buttonBgView.center = CGPoint(x: buttonWidth / 2, y: height / 2)
        
        self.dotView.backgroundColor = dotColor
        self.dotView.frame.size = CGSize(width: dotWidth, height: dotWidth)
        self.dotView.center = CGPoint(x: buttonWidth / 2, y: buttonWidth / 2)
        self.dotView.layer.cornerRadius = dotWidth / 2
        self.dotView.alpha = dotViewAlphaUnselected
        
        self.buttonBgView.addSubview(dotView)
        self.addSubview(buttonBgView)
        
        self.textLbl.textColor = textColor
        self.textLbl.text = text
        self.textLbl.font = textFont
        self.textLbl.frame = CGRect(x: buttonWidth, y: 0, width: text.widthThatFitsContentByHeight(height), height: height)
        self.textLbl.alpha = textLblAlphaUnselected
        self.addSubview(textLbl)
        
        self.frame.size = CGSize(width: buttonWidth+text.widthThatFitsContentByHeight(height), height: height)
        
        // tap event
        let tap = UITapGestureRecognizer(target: self, action: #selector(RatioView.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func select() {
        if !self.isSeleted {
            self.toggleRatioSelection(false)
        }
    }
    
    func deselect() {
        if self.isSeleted {
            self.toggleRatioSelection(false)
        }
//        NSLayoutConstraint(item: <#T##Any#>, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.toggleRatioSelection()
    }
    
    // if animated == true, toggleRatioSelectionCallback will be invoked
    func toggleRatioSelection(_ animated: Bool = true) {
        self.isSeleted = !self.isSeleted
        
        let newDotAlpha: CGFloat = self.isSeleted ? 1 : dotViewAlphaUnselected
        let newTextAlpha: CGFloat = self.isSeleted ? 1 : textLblAlphaUnselected
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.dotView.alpha = newDotAlpha
                self.textLbl.alpha = newTextAlpha
            })
            
            toggleRatioSelectionCallback?(self.isSeleted)
        } else {
            self.dotView.alpha = newDotAlpha
            self.textLbl.alpha = newTextAlpha
        }
    }
    
    deinit {
        self.gestureRecognizers?.forEach({ (gr) in
            self.removeGestureRecognizer(gr)
        })
    }
    
    // MARK: 'init' methods
    // !!!You should invoke one of the init methods everytime you create a new RatioView
    func initRatioView(withIsSelected isSeleted: Bool, text: String, centerPoint: CGPoint, toggleRatioSelectionCallback: ((_ isSelected: Bool)->())?) {
        if self.isSeleted != isSeleted {
            self.toggleRatioSelection(false)
        }
        
        self.toggleRatioSelectionCallback = toggleRatioSelectionCallback
        
        self.text = text
        
        initUI()
        
        self.center = centerPoint
    }
    
    func initRatioView(withIsSeleted isSeleted: Bool, text: String, originPoint: CGPoint, toggleRatioSelectionCallback: ((_ isSelected: Bool)->())?) {
        if self.isSeleted != isSeleted {
            self.toggleRatioSelection(false)
        }
        
        self.toggleRatioSelectionCallback = toggleRatioSelectionCallback
        
        self.text = text
        
        initUI()
        
        self.frame.origin = originPoint
    }

}
