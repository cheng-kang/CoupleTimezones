//
//  AlertViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/14.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    
    var dismissBtnClick: (()->())!
    
    var titleLblText: String!
    var contentLblText: String!
    var dismissBtnTitle: String!
    
    class func vc(title: String, content: String, dismissBtnTitle: String, dismissBtnClick: @escaping (()->())) -> AlertViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        
        vc.titleLblText = title
        vc.contentLblText = content
        vc.dismissBtnTitle = dismissBtnTitle
        vc.dismissBtnClick = dismissBtnClick
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLbl.text = titleLblText
        self.contentLbl.text = contentLblText
        self.dismissBtn.setTitle(dismissBtnTitle, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissBtnClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: { 
            self.view.alpha = 0
        }) { (isSuccess) in
            self.dismissBtnClick()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
