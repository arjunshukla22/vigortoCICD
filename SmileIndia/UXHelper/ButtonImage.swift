//
//  ButtonImage.swift
//  SmileIndia
//
//  Created by Arjun  on 30/07/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation
import UIKit

class ButtonWithImage: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 25), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
