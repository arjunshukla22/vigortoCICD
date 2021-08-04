//
//  UIColorExtension.swift
//  HandstandV2
//
//  Created by user on 20/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit
extension UIColor {
    
    private enum Color {
        case themeGreen
        case DarkthemeGreen
        case disabledText
        case disabledBackground
        case darkText
        case barBackground
        case orangeBg
        case sblue
        case sred
        case sgreen
        case sorange
        case grayTable
        
        var color: UIColor {
            switch self {
            case .themeGreen: return UIColor(red: 80/255, green: 202/255, blue: 160/255, alpha: 1.0)
            case .DarkthemeGreen:  return UIColor(red: 4/255, green: 165/255, blue: 62/255, alpha: 1.0)
            case .disabledText:
                return UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1.0)
            case .disabledBackground:
                return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            case .darkText:
                return UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1.0)
            case .barBackground:
                return UIColor(red: 225/255, green: 224/255, blue: 224/255, alpha: 1.0)
            case .orangeBg:
                return UIColor(red: 255/255, green: 165/255, blue: 62/255, alpha: 1.0)
            case .sorange:
                return UIColor(red: 255/255, green: 148/255, blue: 62/255, alpha: 1.0)
            case .sgreen:
                return UIColor(red: 4/255, green: 165/255, blue: 62/255, alpha: 1.0)
            case .sblue:
                return UIColor(red: 4/255, green: 80/255, blue: 255/255, alpha: 1.0)
            case .sred:
                return UIColor(red: 220/255, green: 53/255, blue: 69/255, alpha: 1.0)
            case .grayTable:
                return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            }
        }
    }
    static var themeGreen : UIColor{
        return Color.themeGreen.color
    }
    static var DarkthemeGreen : UIColor{
        return Color.themeGreen.color
    }
    
    static var disabledText : UIColor{
        return Color.disabledText.color
    }
    static var disabledBackground : UIColor{
        return Color.disabledBackground.color
    }
    static var darkText : UIColor{
        return Color.darkText.color
    }
    static var barBackground : UIColor{
        return Color.barBackground.color
    }
    static var orangeBg : UIColor{
        return Color.orangeBg.color
    }
    static var sorange : UIColor{
        return Color.sorange.color
    }
    static var sgreen : UIColor{
        return Color.sgreen.color
    }
    static var sblue : UIColor{
        return Color.sblue.color
    }
    static var sred : UIColor{
        return Color.sred.color
    }
    static var grayTable : UIColor{
        return Color.grayTable.color
    }
}
