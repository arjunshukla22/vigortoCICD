//
//  AppStoryboard.swift
//  HandstandV2
//
//  Created by user on 24/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit

enum AppStoryboard: String{
    
    case login = "Login"
    case register = "Register"
    case home = "Home"
    case profile = "Profile"
    case member = "Member"
    case appointment = "Appointment"
    case rating = "Rating"
    case map = "map"
    case payments = "Payments"
    case calendar = "calendar"
    case prescription = "prescription"
    case contactus = "Contactus"
    case subscription = "subscription"
    case calls = "calls"
    case rewards = "Rewards"
    case insurance = "insurance"
    case credits = "Credits"
    case socioProfile = "socioProfile"
    case comment = "Comment"
    case socio = "Socio"
    case howitworks = "howitworks"
    case socioFriendList = "socioFriendList"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ controller: T.Type) -> T {
        let storyBoardId = (controller as UIViewController.Type).storyboardId
        return instance.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
}



extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}


//MARK:- ======== ViewController Identifiers ========
extension UIViewController {
    
    static func getVC(_ storyBoard: AppStoryboard) -> Self {
        
        func instanceFromNib<T: UIViewController>(_ storyBoard: AppStoryboard) -> T {
            guard let vc = controller(storyBoard: storyBoard, controller: T.identifier) as? T else {
                fatalError("Not ViewController")
            }
            return vc
        }
        return instanceFromNib(storyBoard)
    }
    
    static func controller(storyBoard: AppStoryboard, controller: String) -> UIViewController {
      
        let storyBoard = UIStoryboard(name: storyBoard.rawValue, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: controller)
        return vc
    }
}
