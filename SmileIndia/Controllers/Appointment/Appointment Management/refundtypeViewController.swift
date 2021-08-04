//
//  refundtypeViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/12/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class refundtypeViewController: UIViewController {
    var  refundOptions: RefundOptions?
    var selectedIndex = 0
    var object: Appointment?
    var appid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appid)
        let alert = UIAlertController(title: AppointmentScreenTxt.initiateRefund.localize(), message: AppointmentScreenTxt.selectOptionForRefund.localize(), preferredStyle: UIAlertController.Style.alert)

       // if refundOptions?.MoneyRefund  == true{
        alert.addAction(UIAlertAction(title: AppointmentScreenTxt.refund.localize(), style: UIAlertAction.Style.default, handler: { action in
            self.initiateRefund("\(self.appid)", optionId: "1")
        }))
        //}
       // if refundOptions?.CreditRefund  == true{
        alert.addAction(UIAlertAction(title: AppointmentScreenTxt.vigortoCredits.localize(), style: UIAlertAction.Style.default, handler: { action in
            self.initiateRefund("\(self.appid)", optionId: "2")
            }))
       // }
        alert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.destructive, handler: nil))
        NavigationHandler.pop()
        // show the alert
        self.present(alert, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    func initiateRefund(_ appId: String ,optionId:String){
        let queryItems = ["AppointmentId": appId
                          ,"SelectedOptionId": optionId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.initiateRefund(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("refund")
                    print(response)
                 
                    AlertManager.showAlert(type: .custom(response.message ?? "")) {
                    if optionId == "2"{
                            NavigationHandler.pushTo(.credits)
                           print("refund")
                        }
                        else{
                        NavigationHandler.pop()
                            print("refund")
                        }
                    }
                case .failure(let error):
                    print("failed refund")
                 //   NavigationHandler.pop()
                  //  NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(error.message)) {
                        self.dismiss(animated: true, completion: nil)
                        NavigationHandler.pop()
                        self.view.layoutIfNeeded()
                    }
                   
                }
               self.view.activityStopAnimating()
            }
        }
    }
 }
