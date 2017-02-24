//
//  ThemeService.swift
//  CoupleTimezones
//
//  Created by Ant on 17/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit

class ThemeService: NSObject {
    static let shared = ThemeService()
    
    var themeStrs = ["default", "default1", "dark purple", "blue", "dark green", "coral", "red", "American Rose"]
    var seletedThemeIndex: Int {
        return themeStrs.index(of: theme) ?? 0
    }
    var theme: String {
        if let userTheme = UserService.shared.get()?.theme {
            return userTheme
        }
        return "dark green"
    }
    var colors: [String:[String:UIColor]] = [
        "default": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 255, green: 255, blue: 255),
            "text_light": UIColor(red: 51, green: 48, blue: 59),
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7),
            "text_grey": UIColor(red: 240, green: 239, blue: 241),
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7),
            "text_dark": UIColor(red: 51, green: 48, blue: 59),
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1),
            "page_element_block": UIColor(red: 51/255, green: 48/255, blue: 59/255, alpha: 0.9),
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 51/255, green: 48/255, blue: 59/255, alpha: 0.6),
            "day_square_light": UIColor(red: 51/255, green: 48/255, blue: 59/255, alpha: 0.4),
            "day_square_dark": UIColor(red: 51, green: 48, blue: 59),
        ],
        "default1": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 255, green: 255, blue: 255),
            "text_light": UIColor(red: 0, green: 0, blue: 0),
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7),
            "text_grey": UIColor(red: 240, green: 239, blue: 241),
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7),
            "text_dark": UIColor(red: 0, green: 0, blue: 0),
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1),
            "page_element_block": UIColor(red: 0, green: 0, blue: 0, alpha: 0.9),
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 204, green: 204, blue: 204),
            "day_square_light": UIColor(red: 204, green: 204, blue: 204),
            "day_square_dark": UIColor(red: 0, green: 0, blue: 0),
        ],
        "dark purple": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 51, green: 48, blue: 59),
            "text_light": UIColor(red: 252, green: 252, blue: 252),
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7),
            "text_grey": UIColor(red: 240, green: 239, blue: 241),
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7),
            "text_dark": UIColor(red: 51, green: 48, blue: 59),
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1),
            "page_element_block": UIColor(red: 68, green: 64, blue: 78),
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 93, green: 87, blue: 107),
            "day_square_light": UIColor(red: 196, green: 193, blue: 201),
            "day_square_dark": UIColor(red: 93, green: 87, blue: 107),
        ],
        "blue": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 81, green: 136, blue: 216), // -10
            "text_light": UIColor(red: 252, green: 252, blue: 252), //Dont'change
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7), //Dont'change
            "text_grey": UIColor(red: 240, green: 239, blue: 241), //Dont'change
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7), //Dont'change
            "text_dark": UIColor(red: 36, green: 60, blue: 95), // -8
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1), //Dont'change
            "page_element_block": UIColor(red: 65, green: 109, blue: 173), // -8
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 81/255, green: 136/255, blue: 216/255, alpha: 0.8), // -10
            "day_square_light": UIColor(red: 65/255, green: 109/255, blue: 173/255, alpha: 0.4), // -8
            "day_square_dark": UIColor(red: 65, green: 109, blue: 173), // -8
        ],
        "dark green": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 113, green: 160, blue: 179),
            "text_light": UIColor(red: 252, green: 252, blue: 252), //Dont'change
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7), //Dont'change
            "text_grey": UIColor(red: 240, green: 239, blue: 241), //Dont'change
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7), //Dont'change
            "text_dark": UIColor(red: 91, green: 128, blue: 143),
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1), //Dont'change
            "page_element_block": UIColor(red: 91, green: 128, blue: 143),
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 113, green: 160, blue: 179),
            "day_square_light": UIColor(red: 91/255, green: 128/255, blue: 143/255, alpha: 0.4),
            "day_square_dark": UIColor(red: 91, green: 128, blue: 143),
        ],
        "coral": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 253, green: 170, blue: 148), // -10
            "text_light": UIColor(red: 252, green: 252, blue: 252), //Dont'change
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7), //Dont'change
            "text_grey": UIColor(red: 240, green: 239, blue: 241), //Dont'change
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7), //Dont'change
            "text_dark": UIColor(red: 252, green: 134, blue: 102), // -8
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1), //Dont'change
            "page_element_block": UIColor(red: 252, green: 134, blue: 102), // -8
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 253, green: 170, blue: 148), // -10
            "day_square_light": UIColor(red: 252/255, green: 134/255, blue: 102/255, alpha: 0.4), // -8
            "day_square_dark": UIColor(red: 252, green: 134, blue: 102), // -8
        ],
        "red": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 229, green: 50, blue: 59), // -10
            "text_light": UIColor(red: 252, green: 252, blue: 252), //Dont'change
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7), //Dont'change
            "text_grey": UIColor(red: 240, green: 239, blue: 241), //Dont'change
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7), //Dont'change
            "text_dark": UIColor(red: 183, green: 40, blue: 47), // -8
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1), //Dont'change
            "page_element_block": UIColor(red: 183, green: 40, blue: 47), // -8
            "page_element_light": UIColor(red: 255, green: 255, blue: 255),
            "page_element_dark": UIColor(red: 229, green: 50, blue: 59), // -10
            "day_square_light": UIColor(red: 183/255, green: 40/255, blue: 40/255, alpha: 0.4), // -8
            "day_square_dark": UIColor(red: 183, green: 40, blue: 40), // -8
        ],
        "American Rose": [
            "bg_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "bg_dark": UIColor(red: 255, green: 94, blue: 132), // -10
            "text_light": UIColor(red: 252, green: 252, blue: 252), //Dont'change
            "text_light_highlighted": UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 0.7), //Dont'change
            "text_grey": UIColor(red: 240, green: 239, blue: 241), //Dont'change
            "text_grey_hightlighted": UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 0.7), //Dont'change
            "text_dark": UIColor(red: 255, green: 3, blue: 62), // -8
            "text_warning": UIColor(red: 1, green: 1, blue: 0, alpha: 1), //Dont'change
            "page_element_block": UIColor(red: 255, green: 3, blue: 62), // -8
            "page_element_light": UIColor(red: 255, green: 255, blue: 255), //Dont'change
            "page_element_dark": UIColor(red: 255, green: 94, blue: 132), // -10
            "day_square_light": UIColor(red: 255/255, green: 3/255, blue: 62/255, alpha: 0.4), // -8
            "day_square_dark": UIColor(red: 255, green: 3, blue: 62), // -8
        ],
    ]
    
    var bg_light: UIColor {
        return colors[theme]!["bg_light"]!
    }
    var bg_dark: UIColor {
        return colors[theme]!["bg_dark"]!
    }
    var text_light: UIColor {
        return colors[theme]!["text_light"]!
    }
    var text_light_highlighted: UIColor {
        return colors[theme]!["text_light_highlighted"]!
    }
    var text_grey: UIColor {
        return colors[theme]!["text_grey"]!
    }
    var text_grey_hightlighted: UIColor {
        return colors[theme]!["text_grey_hightlighted"]!
    }
    var text_dark: UIColor {
        return colors[theme]!["text_dark"]!
    }
    var text_warning: UIColor {
        return colors[theme]!["text_warning"]!
    }
    var page_element_block: UIColor {
        return colors[theme]!["page_element_block"]!
    }
    var page_element_light: UIColor {
        return colors[theme]!["page_element_light"]!
    }
    var page_element_dark: UIColor {
        return colors[theme]!["page_element_dark"]!
    }
    var day_square_light: UIColor {
        return colors[theme]!["day_square_light"]!
    }
    var day_square_dark: UIColor {
        return colors[theme]!["day_square_dark"]!
    }
}
