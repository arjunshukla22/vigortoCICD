//
//  AlertAction+Extension.swift
//  SmileIndia
//
//  Created by Arjun  on 16/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertAction {
    var titleTextColor: UIColor? {
        get { return self.value(forKey: "titleTextColor") as? UIColor }
        set { self.setValue(newValue, forKey: "titleTextColor") }
    }
}
