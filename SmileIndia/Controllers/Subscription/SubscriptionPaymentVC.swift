//
//  SubscriptionPaymentVC.swift
//  SmileIndia
//
//  Created by Sakshi on 11/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SubscriptionPaymentVC: UIViewController {
var subscriptionlink = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.getDoctorPlanDetails()
    }
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapCancel(_ sender: Any)
    {
         NavigationHandler.pushTo(.subscriptionPlans)
    }
    
    @IBAction func didtapMakePayment(_ sender: Any) {
      print(subscriptionlink)
        NavigationHandler.pushTo(.paySubscription(subscriptionlink))
    }
   
    func getDoctorPlanDetails() -> Void {
        let queryItems = ["CustomerId": "\(Authentication.customerGuid!)"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.doctorPlanDetails(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response.object?.SubscriptionLink ?? "")
                        self.subscriptionlink = response.object?.SubscriptionLink ?? ""
                        
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
}
