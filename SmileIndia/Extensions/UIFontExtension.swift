//
//  UIFontExtension.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Size {
        case h1
        case h2
        case h3
        case h4
        case h5
        case h6
        case h7
        case h8
        case custom(size: CGFloat)
        
        var designRefWidth: CGFloat { return 375.0 }
        var isSmallerDevice: Bool { return currentDeviceWidth < designRefWidth }
        
        var currentDeviceWidth: CGFloat { return UIScreen.main.bounds.size.width }
        
        var floatValue: CGFloat {
            switch self {
            case .h1:
                return isSmallerDevice ? (26/designRefWidth) * currentDeviceWidth : 26
            case .h2:
                return isSmallerDevice ? (24/designRefWidth) * currentDeviceWidth : 24
            case .h3:
                return isSmallerDevice ? (22/designRefWidth) * currentDeviceWidth : 22
            case .h4:
                return isSmallerDevice ? (20/designRefWidth) * currentDeviceWidth : 20
            case .h5:
                return isSmallerDevice ? (18/designRefWidth) * currentDeviceWidth : 18
            case .h6:
                return isSmallerDevice ? (16/designRefWidth) * currentDeviceWidth : 16
            case .h7:
                return isSmallerDevice ? (14/designRefWidth) * currentDeviceWidth : 14
            case .h8:
                return isSmallerDevice ? (12/designRefWidth) * currentDeviceWidth : 12
            case .custom(let size):
                return isSmallerDevice ? (size/designRefWidth) * currentDeviceWidth : size
            }
        }
    }
    
    enum Style {
        case black
        case blackItalic
        case bold
        case boldItalic
        case hairline
        case hairlineItalic
        case heavy
        case heavyItalic
        case italic
        case light
        case lightItalic
        case medium
        case mediumItalic
        case regular
        case semibold
        case semiboldItalic
        case thin
        case thinItalic
        
        
        var name: String {
            switch self {
            case .black: return "Lato-Black"
            case .blackItalic: return "Lato-BlackItalic"
            case .bold: return "Lato-Bold"
            case .boldItalic: return "Lato-BoldItalic"
            case .hairline: return "Lato-Hairline"
            case .hairlineItalic: return "Lato-HairlineItalic"
            case .heavy: return "Lato-Heavy"
            case .heavyItalic: return "Lato-HeavyItalic"
            case .italic: return "Lato-Italic"
            case .light: return "Lato-Light"
            case .lightItalic: return "Lato-LightItalic"
            case .medium: return "Lato-Medium"
            case .mediumItalic: return "Lato-MediumItalic"
            case .regular: return "Lato-Regular"
            case .semibold: return "Lato-Semibold"
            case .semiboldItalic: return "Lato-SemiboldItalic"
            case .thin: return "Lato-Thin"
            case .thinItalic: return "Lato-ThinItalic"
            }
        }
    }
    
    convenience init(style: Style, size: Size) {
        self.init(name: style.name, size: size.floatValue)!
    }
}
