//
//  UIButtonExtension.swift
//  HandstandV2
//
//  Created by user on 15/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func disableButton()  {
        self.alpha = 0.6
        self.isUserInteractionEnabled = false
    }
    
    func enableButton()  {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
    }
    
    func enableColoredButton() {
        self.isEnabled = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.themeGreen
        self.isUserInteractionEnabled = true
    }
    
    func disableColoredButton() {
        self.isEnabled = false
        self.setTitleColor(UIColor.disabledText, for: .normal)
        self.backgroundColor = UIColor.disabledBackground
        self.isUserInteractionEnabled = false
    }
    
    func setAccessibilityLabel(label : String)  {
        self.accessibilityLabel = label
    }
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }

    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func hasImage(named imageName: String, for state: UIControl.State) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }

        return buttonImage.pngData() == namedImage.pngData()
    }
    
    func alignTextBelow(spacing: CGFloat = 0.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }

}


