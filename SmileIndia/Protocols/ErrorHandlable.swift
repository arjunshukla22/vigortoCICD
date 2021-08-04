//
//  ErrorHandlable.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit
protocol ErrorHandlable {
    func showError(title: String?, message: String)
}

extension ErrorHandlable where Self: UIViewController {
    
    func showError(title: String? = "Hey there!", message: String) {
        AlertManager.showAlert(on: self, type: .custom(message))
    }
    
}
