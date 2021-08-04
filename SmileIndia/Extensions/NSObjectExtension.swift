//
//  NSObjectExtension.swift
//  SmileIndia
//
//  Created by Arjun  on 11/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
    func getTopMostViewControllerForNSObject() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}
