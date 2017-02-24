//
//  Theme.swift
//  CoupleTimezones
//
//  Created by Ant on 24/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class Theme: NSObject {
    static let shared = Theme()
    
    var themeStrs = ["default"]
    var seletedThemeIndex: Int {
        return themeStrs.index(of: theme) ?? 0
    }
    var theme: String {
        if let userTheme = UserService.shared.get()?.theme {
            return userTheme
        }
        return "default"
    }
    var colors: [String:[String:UIColor]] = [
        "default": [
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 215, green: 22, blue: 27),
            "banner_bottom_line": UIColor(red: 215, green: 22, blue: 27),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 93, green: 93, blue: 93),
            "alarm_cell_delete_btn": UIColor(red: 0, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 93, green: 93, blue: 93),
            "switch_bg_inactive": UIColor(red: 255, green: 255, blue: 255),
            "datepicker_text": UIColor(red: 0, green: 0, blue: 0),
            "edit_alarm_cell_title": UIColor(red: 0, green: 0, blue: 0),
            "edit_alarm_cell_right_detail": UIColor(red: 0, green: 0, blue: 0),
            "radio_border": UIColor(red: 0, green: 0, blue: 0),
            "radio_bg": UIColor(red: 255, green: 255, blue: 255),
            "radio_block": UIColor(red: 0, green: 0, blue: 0),
            "radio_text_active": UIColor(red: 0, green: 0, blue: 0),
            "radio_text_inactive": UIColor(red: 0, green: 0, blue: 0, alpha: 0.7),
            "repeat_cell_text": UIColor(red: 0, green: 0, blue: 0),
            "tag_input_border": UIColor(red: 0, green: 0, blue: 0),
            "tag_input_text": UIColor(red: 0, green: 0, blue: 0),
            "form_bg": UIColor(red: 255, green: 255, blue: 255),
            "form_text": UIColor(red: 0, green: 0, blue: 0),
            "form_text_warning": UIColor(red: 1, green: 1, blue: 0),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ]
    ]
    
    var banner_btn: UIColor {
        return colors[theme]!["banner_btn"]!
    }
    var banner_text: UIColor {
        return colors[theme]!["banner_text"]!
    }
    var banner_balloon: UIColor {
        return colors[theme]!["banner_balloon"]!
    }
    var banner_bottom_line: UIColor {
        return colors[theme]!["banner_bottom_line"]!
    }
    var alarm_cell_text_active: UIColor {
        return colors[theme]!["alarm_cell_text_active"]!
    }
    var alarm_cell_text_inactive: UIColor {
        return colors[theme]!["alarm_cell_text_inactive"]!
    }
    var alarm_cell_day_active: UIColor {
        return colors[theme]!["alarm_cell_day_active"]!
    }
    var alarm_cell_day_inactive: UIColor {
        return colors[theme]!["alarm_cell_day_inactive"]!
    }
    var alarm_cell_edit_btn: UIColor {
        return colors[theme]!["alarm_cell_edit_btn"]!
    }
    var alarm_cell_delete_btn: UIColor {
        return colors[theme]!["alarm_cell_delete_btn"]!
    }
    var switch_border: UIColor {
        return colors[theme]!["switch_border"]!
    }
    var switch_block: UIColor {
        return colors[theme]!["switch_block"]!
    }
    var switch_bg_active: UIColor {
        return colors[theme]!["switch_bg_active"]!
    }
    var switch_bg_inactive: UIColor {
        return colors[theme]!["switch_bg_inactive"]!
    }
    var datepicker_text: UIColor {
        return colors[theme]!["datepicker_text"]!
    }
    var edit_alarm_cell_title: UIColor {
        return colors[theme]!["edit_alarm_cell_title"]!
    }
    var edit_alarm_cell_right_detail: UIColor {
        return colors[theme]!["edit_alarm_cell_right_detail"]!
    }
    var radio_border: UIColor {
        return colors[theme]!["radio_border"]!
    }
    var radio_bg: UIColor {
        return colors[theme]!["radio_bg"]!
    }
    var radio_block: UIColor {
        return colors[theme]!["radio_block"]!
    }
    var radio_text_active: UIColor {
        return colors[theme]!["radio_text_active"]!
    }
    var radio_text_inactive: UIColor {
        return colors[theme]!["radio_text_inactive"]!
    }
    var repeat_cell_text: UIColor {
        return colors[theme]!["repeat_cell_text"]!
    }
    var tag_input_border: UIColor {
        return colors[theme]!["tag_input_border"]!
    }
    var tag_input_text: UIColor {
        return colors[theme]!["tag_input_text"]!
    }
    var form_bg: UIColor {
        return colors[theme]!["form_bg"]!
    }
    var form_text: UIColor {
        return colors[theme]!["form_text"]!
    }
    var form_text_warning: UIColor {
        return colors[theme]!["form_text_warning"]!
    }
    var form_text_error: UIColor {
        return colors[theme]!["form_text_error"]!
    }
    var form_btn: UIColor {
        return colors[theme]!["form_btn"]!
    }
}
