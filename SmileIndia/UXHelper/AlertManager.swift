//
//  AlertManager.swift
//  Chnen
//
//  Created by user on 14/05/18.
//  Copyright © 2018 navjot_sharma. All rights reserved.
//

import UIKit
import Localize

enum Prompt {
    
    case networkUnavailable
    case serverNotResponding
    case custom(String)
        
    var message: String? {
        
        switch self {
        case .networkUnavailable:
            return ""
        case .serverNotResponding:
            return ""
        case .custom(let message):
            return message
        }
    }
}

class AlertManager {
    
    typealias actionHandler = ()->()
    
    static func showAlert(on target: UIViewController? = nil,type: Prompt) {
        
        if type.message == "" {
            return
        }
        
        let alert = UIAlertController.init(title: nil, message: type.message, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertBtnTxt.okay.localize(), style: UIAlertAction.Style.default, handler: {Void in})
        alert.addAction(action)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let rootController = delegate.window?.rootViewController else { return }
        
//        if let controller = target {
//            controller.present(alert, animated: true, completion: nil)
//        } else {
            rootController.present(alert, animated: true, completion: nil)
//        }
    }
    
    static func showAlert(type:Prompt, title: String? = nil, action:@escaping actionHandler){
    
        if type.message == "" {
            return
        }
        
        let alert = UIAlertController(title: nil, message: type.message, preferredStyle: .alert)
        let action = UIAlertAction(title: title ?? AlertBtnTxt.okay.localize(), style: .default) { (_) in
            action()
        }
        alert.addAction(action)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let controller = delegate.window?.rootViewController else { return }
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(type:Prompt, actionTitle: String, action:@escaping actionHandler){
        
        if type.message == "" {
            return
        }
        
        let alert = UIAlertController.init(title: nil, message: type.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: AlertBtnTxt.cancel.localize(), style: .cancel, handler: nil)
        let action = UIAlertAction.init(title: actionTitle, style: .default) { (_) in
            action()
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let controller = delegate.window?.rootViewController else { return }
        
        controller.present(alert, animated: true, completion: nil)
        
    }
}
