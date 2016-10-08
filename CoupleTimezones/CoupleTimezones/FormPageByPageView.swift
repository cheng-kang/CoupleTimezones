//
//  FormPageByPageView.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/7.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class FormPageByPageView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let titleLbl = UILabel()
    let scrollview = UIScrollView()
    let prevBtn = UIButton()
    let nextBtn = UIButton()
    let pageLbl = UILabel()
    
    var margin: CGFloat = 20
    var titleLblY: CGFloat = 60
    var titleLblHeight: CGFloat = 50
    var titleLblToTop: CGFloat = 60
    var titleLblToLeft: CGFloat = 20
    
    var scrollviewToLeft: CGFloat = 20
    var scrollviewToRight: CGFloat = 20
    var scrollviewToTop: CGFloat = 8
    var scrollviewToBottom: CGFloat = 8
    
    var prevBtnTitle = "上一页"
    var prevBtnTitleS = "第一页"
    var nextBtnTitle = "下一页"
    var nextBtnTitleS = "完成"
    
    var prevBtnToLeft: CGFloat = 20
    var prevBtnToScrollview: CGFloat = 25
    
    var nextBtnLeftToPrevBtn: CGFloat = 10
    
    var pageLblToLeft: CGFloat = 20
    var pageLblToBottom: CGFloat = 30
    
    var lightColor: UIColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
    var lightColorHighlighted: UIColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7)
    var greyColor: UIColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
    var bgColor: UIColor = UIColor(red: 93/255, green: 87/255, blue: 107/255, alpha: 1)
    
    var customFontName = ""
    
    var title = "" {
        didSet {
            self.titleLbl.text = title
        }
    }
    var contents = [Any]()
    
    var anwsers = [String]()
    
    var currentPageIndex = 0 {
        didSet {
            self.pageLbl.text = "\(currentPageIndex+1)/\(contents.count)"
            
            if isLastPage {
                self.nextBtn.setTitle(nextBtnTitleS, for: .normal)
            } else {
                self.nextBtn.setTitle(nextBtnTitle, for: .normal)
            }
            
            if isFirstPage {
                self.prevBtn.setTitle(prevBtnTitleS, for: .normal)
                self.prevBtn.isEnabled = false
            } else {
                self.prevBtn.setTitle(prevBtnTitle, for: .normal)
                self.prevBtn.isEnabled = true
            }
        }
    }
    
    var isLastPage: Bool {
        return currentPageIndex == contents.count - 1
    }
    var isFirstPage: Bool {
        return currentPageIndex == 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initUI() {
        self.isUserInteractionEnabled = true
        self.prevBtn.isUserInteractionEnabled = true
        self.backgroundColor = bgColor
        
        self.addSubview(titleLbl)
        self.addSubview(scrollview)
        self.addSubview(prevBtn)
        self.addSubview(nextBtn)
        self.addSubview(pageLbl)
        
        self.titleLbl.translatesAutoresizingMaskIntoConstraints = false
        self.scrollview.translatesAutoresizingMaskIntoConstraints = false
        self.prevBtn.translatesAutoresizingMaskIntoConstraints = false
        self.nextBtn.translatesAutoresizingMaskIntoConstraints = false
        self.pageLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // init titleLbl UI
        self.titleLbl.textAlignment = .left
        self.titleLbl.textColor = lightColor
        
        if let font = UIFont(name: customFontName, size: 40) {
            self.titleLbl.font = font
        } else {
            self.titleLbl.font = UIFont(name: "System", size: 40)
        }
        
        // init scrollview
        self.scrollview.isScrollEnabled = false
        self.scrollview.backgroundColor = UIColor.clear
        
        // init page btns
        self.prevBtn.tintColor = lightColor
        self.prevBtn.setTitleColor(lightColorHighlighted, for: .highlighted)
        self.prevBtn.setTitleColor(lightColorHighlighted, for: .disabled)
        
        if let font = UIFont(name: customFontName, size: 20) {
            self.prevBtn.titleLabel?.font = font
        } else {
            self.prevBtn.titleLabel?.font = UIFont(name: "System", size: 20)
        }
        
        self.nextBtn.tintColor = lightColor
        self.nextBtn.setTitleColor(lightColorHighlighted, for: .highlighted)
        self.nextBtn.setTitleColor(lightColorHighlighted, for: .disabled)
        
        if let font = UIFont(name: customFontName, size: 20) {
            self.nextBtn.titleLabel?.font = font
        } else {
            self.nextBtn.titleLabel?.font = UIFont(name: "System", size: 20)
        }
        
        // bind click events
        self.prevBtn.addTarget(self, action: #selector(FormPageByPageView.prevBtnClick), for: .touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(FormPageByPageView.nextBtnClick), for: .touchUpInside)
        
        // init pageLbl UI
        self.pageLbl.textAlignment = .left
        self.pageLbl.textColor = lightColor
        
        if let font = UIFont(name: customFontName, size: 17) {
            self.pageLbl.font = font
        } else {
            self.pageLbl.font = UIFont(name: "System", size: 17)
        }
        
        // init titleLbl pageLbl scrollview constraints
        let titleLblToLeftConstraint = NSLayoutConstraint(item: self.titleLbl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: titleLblToLeft)
        let titleLblToTopConstaint = NSLayoutConstraint(item: self.titleLbl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: titleLblToTop)
        
        let scroolviewToLeftConstraint = NSLayoutConstraint(item: self.scrollview, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let scroolviewToRightConstraint = NSLayoutConstraint(item: self.scrollview, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let scroolviewHeightConstraint = NSLayoutConstraint(item: self.scrollview, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        let scroolviewVerticalCenterConstraint = NSLayoutConstraint(item: self.scrollview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        let prevBtnToLeftConstraint = NSLayoutConstraint(item: self.prevBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: prevBtnToLeft)
        let prevBtnToScrollviewConstraint = NSLayoutConstraint(item: self.prevBtn, attribute: .top, relatedBy: .equal, toItem: self.scrollview, attribute: .bottom, multiplier: 1, constant: prevBtnToScrollview)
        
        let nextBtnLeftToPrevBtnConstraint = NSLayoutConstraint(item: self.nextBtn, attribute: .leading, relatedBy: .equal, toItem: self.prevBtn, attribute: .trailing, multiplier: 1, constant: nextBtnLeftToPrevBtn)
        let nextBtnTopConstraint = NSLayoutConstraint(item: self.nextBtn, attribute: .top, relatedBy: .equal, toItem: self.prevBtn, attribute: .top, multiplier: 1, constant: 0)
        
        let pageLblToLeftConstraint = NSLayoutConstraint(item: self.pageLbl, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: pageLblToLeft)
        let pageLblToBottomConstraint = NSLayoutConstraint(item: self.pageLbl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -pageLblToBottom)
        
        self.addConstraints([titleLblToTopConstaint, titleLblToLeftConstraint, pageLblToLeftConstraint, pageLblToBottomConstraint, scroolviewHeightConstraint, scroolviewToLeftConstraint, scroolviewToRightConstraint, scroolviewVerticalCenterConstraint, prevBtnToLeftConstraint, prevBtnToScrollviewConstraint, nextBtnTopConstraint, nextBtnLeftToPrevBtnConstraint])
    }
    
    func configureView(withTitle title: String, contents: [Any], currentPageIndex: Int = 0, customFontName: String = "") {
        // configuration
        self.title = title
        self.contents = contents
        self.currentPageIndex = currentPageIndex
        self.customFontName = customFontName
        
        // initUI
        self.initUI()
        
        // init scroll view content
        for item in contents {
            let content = item as! [Any]
            let contentTitle = content[0] as! String
            let contentDesc = content[1] as! String
            let isRequired = content[2] as! Bool
            
            let boxView = UIView()
            let sectionTitleLbl = UILabel()
            let sectionTitleAdditionLbl = UILabel()
            let errorMsgLbl = UILabel()
            let textField = UITextField()
            let sectionDescLbl = UILabel()
            let sectionDescTextView = UITextView()
            
            let boxWidth = self.scrollview.frame.width
            let boxHeight = self.scrollview.frame.height
            
            boxView.frame = CGRect(x: 0, y: 0, width: boxWidth, height: boxHeight)
            boxView.backgroundColor = UIColor.green
            
            self.scrollview.addSubview(boxView)
        }
    }
    
    func prevBtnClick() {
        if !isFirstPage {
            self.currentPageIndex -= 1
        } else {
            
        }
    }
    
    func nextBtnClick() {
        if !isLastPage {
            self.currentPageIndex += 1
        } else {
            
        }
    }

}
