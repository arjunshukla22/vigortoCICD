//
//  UINavigationBarExtension.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func flatBar(with backgroundColor: UIColor = UIColor.white) {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.barTintColor = UIColor.white
    }
}
