//
//  SubscriptionVC.swift
//  SmileIndia
//
//  Created by Sakshi on 10/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SubscriptionVC: UIViewController {
    
    var isComingFrom = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBar(color: .themeGreen)
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        
        if isComingFrom == "Login" {
            //NavigationHandler.popTo(HomeViewController.self)
            
            NavigationHandler.pushTo(.homeViewController)
        }else{
            NavigationHandler.pop()
        }
        
       
    }
    
    @IBAction func didtapSubscription(_ sender: Any) {
        NavigationHandler.pushTo(.subscriptionPlans)
    }
    
}
