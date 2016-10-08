//
//  SettingStepByStepViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 16/10/7.
//  Copyright © 2016年 Ant. All rights reserved.
//

import UIKit

class SettingStepByStepViewController: UIViewController {
    
    @IBOutlet weak var FormView: FormPageByPageView!
    var finishCallback: ((_ anwsers: [String])->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.FormView.configureView(withTitle: "设置", contents: [["昵称","你的昵称",true], ["密码","一个密码",false], ["时区","你的时区",false]], currentPageIndex: 0, customFontName: "FZYanSongS-R-GB")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func vc(finishCallback: ((_ anwsers: [String])->())?) -> SettingStepByStepViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SettingStepByStepViewController") as! SettingStepByStepViewController
        vc.finishCallback = finishCallback
        
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

}
