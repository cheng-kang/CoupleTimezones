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
    
    var themeStrs: [String] = [
        NSLocalizedString("Default", comment: "默认"),
        NSLocalizedString("Azure", comment: "天蓝"),
        NSLocalizedString("Denim", comment: "牛仔"),
        NSLocalizedString("Emerald", comment: "祖母绿"),
        NSLocalizedString("Jade", comment: "翡翠"),
        NSLocalizedString("Lemon", comment: "柠檬"),
        NSLocalizedString("Fuchsia", comment: "海棠"),
    ]
    var seletedThemeIndex: Int {
        return themeStrs.index(of: theme) ?? 0
    }
    var theme: String {
        if let userTheme = UserService.shared.get()?.theme {
            if themeStrs.contains(userTheme) {
                return userTheme
            }
        }
        return NSLocalizedString("Default", comment: "默认")
    }
    var colors: [String:[String:UIColor]] = [
        NSLocalizedString("Default", comment: "默认"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 215, green: 22, blue: 27),
            "banner_bottom_line": UIColor(red: 215, green: 22, blue: 27),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Azure", comment: "天蓝"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 0, green: 127, blue: 255),
            "banner_bottom_line": UIColor(red: 0, green: 127, blue: 255),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Denim", comment: "牛仔"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 21, green: 96, blue: 189),
            "banner_bottom_line": UIColor(red: 21, green: 96, blue: 189),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Emerald", comment: "祖母绿"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 80, green: 200, blue: 120),
            "banner_bottom_line": UIColor(red: 80, green: 200, blue: 120),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Jade", comment: "翡翠"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 0, green: 168, blue: 107),
            "banner_bottom_line": UIColor(red: 0, green: 168, blue: 107),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Lemon", comment: "柠檬"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 254, green: 254, blue: 34),
            "banner_bottom_line": UIColor(red: 254, green: 254, blue: 34),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ],
        NSLocalizedString("Fuchsia", comment: "海棠"): [
            "banner_bg": UIColor(red: 255, green: 255, blue: 255),
            "banner_btn": UIColor(red: 0, green: 0, blue: 0),
            "banner_text": UIColor(red: 0, green: 0, blue: 0),
            "banner_balloon": UIColor(red: 255, green: 0, blue: 255),
            "banner_bottom_line": UIColor(red: 255, green: 0, blue: 255),
            "alarm_cell_text_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_text_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_day_active": UIColor(red: 0, green: 0, blue: 0),
            "alarm_cell_day_inactive": UIColor(red: 204, green: 204, blue: 204),
            "alarm_cell_edit_btn": UIColor(red: 130, green: 130, blue: 130),
            "alarm_cell_delete_btn": UIColor(red: 255, green: 0, blue: 0),
            "upload_btn": UIColor(red: 255, green: 255, blue: 255),
            "download_btn": UIColor(red: 255, green: 255, blue: 255),
            "switch_border": UIColor(red: 0, green: 0, blue: 0),
            "switch_block": UIColor(red: 0, green: 0, blue: 0),
            "switch_bg_active": UIColor(red: 204, green: 204, blue: 204),
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
            "form_desc": UIColor(red: 93, green: 93, blue: 93),
            "form_text_highlighted": UIColor(red: 204, green: 204, blue: 204),
            "form_text_warning": UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            "form_text_error": UIColor(red: 255, green: 0, blue: 0),
            "form_btn": UIColor(red: 255, green: 255, blue: 255)
        ]
    ]
    
    var banner_bg: UIColor {
        return colors[theme]!["banner_bg"]!
    }
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
    var upload_btn: UIColor {
        return colors[theme]!["upload_btn"]!
    }
    var download_btn: UIColor {
        return colors[theme]!["download_btn"]!
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
    var form_desc: UIColor {
        return colors[theme]!["form_desc"]!
    }
    var form_text_highlighted: UIColor {
        return colors[theme]!["form_text_highlighted"]!
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
