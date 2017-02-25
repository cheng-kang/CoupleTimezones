//
//  EditTagViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/6.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class EditTagViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tagFiled: UITextField!
    @IBOutlet weak var tagFieldCenterY: NSLayoutConstraint!
    
    var tag = ""
    var editTagCallback: ((_ tag: String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tagFiled.delegate = self
        
        self.tagFiled.layer.borderColor = Theme.shared.tag_input_border.cgColor
        self.tagFiled.layer.borderWidth = 1
        self.tagFiled.layer.cornerRadius = 4
        self.tagFiled.textColor = Theme.shared.tag_input_text
        
        self.tagFiled.text = tag
        
        self.tagFiled.becomeFirstResponder()
        
        // Init theme color
        self.bannerView.backgroundColor = Theme.shared.banner_bg
        self.titleLbl.textColor = Theme.shared.banner_text
        self.backBtn.tintColor = Theme.shared.banner_btn
        self.tagFiled.textColor = Theme.shared.banner_btn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func vc(withTag tag: String, editTagCallback: ((_ tag: String)->())?) -> EditTagViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditTagViewController") as! EditTagViewController
        vc.tag = tag
        vc.editTagCallback = editTagCallback
        
        return vc
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backBtnClick(_ sender: UIButton) {
        self.editTagCallback?(self.tagFiled.text!)
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditTagViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tagFieldCenterY.constant = -45
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tagFieldCenterY.constant = 0
    }
}
