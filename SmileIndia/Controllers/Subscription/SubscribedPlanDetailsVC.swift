//
//  SubscribedPlanDetailsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 01/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SubscribedPlanDetailsVC: UIViewController {
    var subscriptionlink = ""
    var RazorPaySubscriptionId = ""
    var nav_flag = ""
    @IBOutlet var btnInfo: UIButton!
    
    @IBOutlet weak var scrptnImageView: UIImageView!
    
    @IBOutlet weak var timeremainingLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var purchasedAtLabel: UILabel!
    
    @IBOutlet weak var btnCancelPlan: UIButton!
    @IBOutlet weak var btnUpgradePlan: UIButton!
    
    @IBOutlet weak var startDateDisplayLbl: UILabel!
    @IBOutlet weak var endDateDisplayLbl: UILabel!
    
    @IBOutlet weak var subscrbedplanDetailheight: NSLayoutConstraint!{
        didSet{
            subscrbedplanDetailheight.constant =  0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getSubscribedPlanDetails()
    }
    
    func getSubscribedPlanDetails() -> Void {
        let queryItems = ["CustomerGuId": "\(Authentication.customerGuid!)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.btnUpgradePlan.isHidden = response.object?.IsTrial ?? false
                        self.btnCancelPlan.isHidden = !(response.object?.IsTrial ?? false)
                        
                        if response.object?.IsTrial! == true{
                            self.subscrbedplanDetailheight.constant =  0
                            self.startDateDisplayLbl.text = SubscriptionScreenText.TrialStartDate.localize()
                            self.endDateDisplayLbl.text = SubscriptionScreenText.TrialExpiredDate.localize()
                        //    self.planNameLabel.text = "\(response.object?.PlanName ?? "")"
                         //   self.planNameLabel.text = "\(response.object?.PlanName ?? "")" + " (Free Trial for \(response.object?.TrialDays ?? 0) Days)"
                            
                            self.planNameLabel.text = /response.object?.PlanName +  "  (\(SubscriptionScreenText.FreeTrial.localize()) \(/response.object?.TrialDays) \(SubscriptionScreenText.days.localize()))"
                            
//                          self.planNameLabel.text = "\(response.object?.PlanName ?? "")" + SubscriptionScreenText.FreeTrial.localize() + "\(response.object?.TrialDays ?? 0)" + SubscriptionScreenText.days.localize() + ")"
                            self.attributingWithColorForVC2(label: self.timeremainingLabel, boldTxt: SubscriptionScreenText.YouAreUsing.localize(), regTxt: "\(response.object?.PlanName ?? "")!" + SubscriptionScreenText.trailPeriod.localize(), color: .themeGreen, fontSize: 15, firstFontWeight: .semibold, secFontWeight: .bold)
                        }else{
                            self.subscrbedplanDetailheight.constant =  44
                            self.startDateDisplayLbl.text = SubscriptionScreenText.StartDate.localize()
                            self.endDateDisplayLbl.text = SubscriptionScreenText.ExpiredDate.localize()
                            
                            self.planNameLabel.text = response.object?.PlanName ?? ""
                            self.attributingWithColorForVC2(label: self.timeremainingLabel, boldTxt: SubscriptionScreenText.YouAreUsing.localize(), regTxt: "\(response.object?.PlanName ?? "")!", color: .themeGreen, fontSize: 15, firstFontWeight: .semibold, secFontWeight: .bold)
                        }
                        self.startDateLabel.text =  self.getFormattedDate(strDate:response.object?.CreatedDate?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
                        self.endDateLabel.text = self.getFormattedDate(strDate: response.object?.Expire_by?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
                        
                        
                        //                            if /response.object?.SubscriptionTypeId == 6{ // on Upgrade Btn Hide
                        //                                self.btnUpgradePlan.isHidden = true
                        //                            }
                        
                        // Arjun Code
                        if /response.object?.DurationOfPlan == 2 && /response.object?.PlanName?.uppercased() == "PLATINUM PLAN" { // on Upgrade Btn Hide
                            self.btnUpgradePlan.isHidden = true
                        }
                        
                        //self.purchasedAtLabel.text = "$ \(response.object?.PurchasedAtPrice ?? 0)"
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func subscriptionCancelAPI(){
        let queryItems = ["CustomerEmail":Authentication.customerEmail ?? ""]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.subscriptionCancelAPI(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? "")){
                        //NavigationHandler.popTo(HomeViewController.self)
                        NavigationHandler.pushTo(.homeViewController)
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    @IBAction func didtapInfo(_ sender: Any) {
        AlertManager.showAlert(type: .custom(SubscriptionScreenText.SubInfo.localize())){
            NavigationHandler.pushTo(.contactUs)
        }
    }
    @IBAction func didtapBack(_ sender: Any) {
        //   NavigationHandler.popTo(HomeViewController.self)
        NavigationHandler.pushTo(.homeViewController)
        
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        self.subscriptionCancelAPI()
    }
    @IBAction func didtapUpgrade(_ sender: Any) {
        NavigationHandler.pushTo(.subscriptionPlans)
    }
    
    @IBAction func didtapAvailablePlans(_ sender: Any) {
        NavigationHandler.pushTo(.subscriptionPlans)
    }
    
    @IBAction func didtapPaymentStatus(_ sender: Any) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = SubscriptionScreenText.payment.localize()
        termsVc.requestURLString = self.subscriptionlink
        self.present(termsVc, animated: true, completion: nil)
    }
}


