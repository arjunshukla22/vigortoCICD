//
//  BaseNavigationController.swift
//  HandstandV2
//
//  Created by user on 25/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit
import Localize

class BaseNavigationController: UINavigationController {

    static var sharedInstance = BaseNavigationController()
    override func viewDidLoad() {
        super.viewDidLoad()
        type(of: self).sharedInstance = self
        configure()
        setDefaultAppearance()
      //  SetUpAppLanguage()
    }
    
    func SetUpAppLanguage(){
        let locale = Locale.preferredLanguages.first?.components(separatedBy: "-").first?.lowercased() ?? "es"
        print(locale)
        
        Localize.shared.update(language: "es")
        
        print(WelcomeScreenTxt.logIn.localize())
       
//        for language in Localize.availableLanguages {
//            let displayName = Localize.displayNameForLanguage(language)
//            print("displayName:- \(displayName)")
//
//        }
        
    }
  
    func setupNavigationBar(_ leftButton: UIBarButtonItem, _ rightButton: UIBarButtonItem, _ title: String)  {
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationController?.title = title
    }
    
    fileprivate func configure() {
        if Authentication.isUserLoggedIn! {
            if Authentication.customerType == "Doctor" {

                BaseNavigationController.sharedInstance.setRoot(.appointmentList("0"))
               // self.setRoot(.feed)
            }else
            {
                self.setRoot(.homeViewController)
            }
        }
        else {
            self.setRoot(.welcome)
        }
    }
    func paidDoctorPlans(guid:String) -> Void {
        let queryItems = ["CustomerGuid": guid]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
        DispatchQueue.main.async {
        switch result {
         case .success(let response):
             if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                BaseNavigationController.sharedInstance.setRoot(.appointmentList("0"))
             }else{
                NavigationHandler.pushTo(.subscriptionVC)
             }
         case .failure:
            NavigationHandler.pushTo(.subscriptionVC)
            }
            self.view.activityStopAnimating()
              }
           }
        }
    // set default navigation appearance
    func setDefaultAppearance() {
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.231372549, green: 0.8156862745, blue: 0.537254902, alpha: 1)
        UINavigationBar.appearance().tintColor = .none
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),NSAttributedString.Key.foregroundColor : UIColor.black]
        
        // set default uisearchbar tint color to white
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
//            [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
    }
    
    // set root controller
    func setRoot(_ screen: PushScreen) {
        viewControllers = [screen.controller]
    }
    
    // push to view controller
    func push(to screen: PushScreen) {
        self.pushViewController(screen.controller, animated: true)
    }
}

class  NavigationHandler {
    
    class func pushTo(_ screen: PushScreen) {
        BaseNavigationController.sharedInstance.push(to: screen)
    }
    
    class func hideNavigationBar() {
        DispatchQueue.main.async {
          BaseNavigationController.sharedInstance.isNavigationBarHidden = true
        }
    }
    
    class func showNavigationBar() {
        DispatchQueue.main.async {
          BaseNavigationController.sharedInstance.isNavigationBarHidden = false
        }
    }
    
    class func pop() {
        BaseNavigationController.sharedInstance.popViewController(animated: true)
    }
    
    class func popTo(_ controller: UIViewController.Type) {
        BaseNavigationController.sharedInstance.viewControllers.forEach {
            if $0.isKind(of: controller) {
                BaseNavigationController.sharedInstance.popToViewController($0, animated: true)
                return
            }
        }        
    }
    
    class func setRoot(_ controller: UIViewController) {
        BaseNavigationController.sharedInstance.viewControllers = [controller]
    }
    
    class func setRoot(_ screen: PushScreen) {
        BaseNavigationController.sharedInstance.viewControllers = [screen.controller]
    }
    
    class var stack: [UIViewController] {
        return BaseNavigationController.sharedInstance.viewControllers
    }
    
    class func loggedIn() {
        BaseNavigationController.sharedInstance.setRoot(.homeViewController)
    }
    
    class func logOut() {
        BaseNavigationController.sharedInstance.setRoot(.welcome)
    }
}


extension UINavigationController {

    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }

    func popPushToVC(ofKind kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            pushViewController(pushController, animated: true)
        }
    }
}
