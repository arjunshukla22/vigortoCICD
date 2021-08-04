//
//  PlanCheckoutDetailsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 30/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Stripe

struct PlanDetails {
    
    let title : String?
    let Description : String?
    
}


class PlandetailsTVC : UITableViewCell{
    @IBOutlet weak var planLabelTxt: UILabel!
}

class PlanCheckoutDetailsVC: UIViewController {
    
    var PlanDetailsArr = [PlanDetails]()
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var stepstoDelete: UILabel!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var planFeeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountView: UIView!
    
    
    @IBOutlet weak var planDetailsTblVw: UITableView!
    
    
    var customerContext : STPCustomerContext?
    var paymentContext : STPPaymentContext?
    var isSetShipping = true
    var RazorPaySubscriptionId = ""
    var totalPrice = ""
    var tax = ""
    var createdOn = ""
    var displayOrder = "0"
    var object: SubscriptionPlans?
    
    var isSubscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.paidDoctorPlans()
        getPlanDetail(planId: "\(object?.SubscriptionPlansMaster?.id ?? 0)", duration: "\(object?.PlanDuration ?? 0)")
        
        let config = STPPaymentConfiguration.shared()
        config.shippingType = .shipping
        config.requiredShippingAddressFields = Set<STPContactField>(arrayLiteral: STPContactField.name,STPContactField.emailAddress,STPContactField.phoneNumber,STPContactField.postalAddress)
        config.companyName = "http://vigorto.com"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext =  STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.hostViewController = self
        setupLbl()
    }
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // verification doc
        noteLabel.attributedText = SubscriptionScreenText.note.localize().highlightWordsIn(highlightedWords: SubscriptionScreenText.noteHead.localize(), attributes: attributes)
        stepstoDelete.attributedText = SubscriptionScreenText.stepstoDelete.localize().highlightWordsIn(highlightedWords: SubscriptionScreenText.stepstoDeleteHead.localize(), attributes: attributes)
        
       
    }
    
    func getPlanDetail(planId:String,duration:String) -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)", "PlanId": planId,"PlanDuration":duration]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.planDetail(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    if (response.object?.Discount ?? 0) == 0{
                        self.discountView.isHidden = true
                    }
                    
                    if response.object?.IsTrial! == true{
                        self.planLabel.text = "\(response.object?.PlanName ?? "")" + " (\(response.object?.TrialDays ?? 0) Days Free)"
                    }else{
                        self.planLabel.text = "\(response.object?.PlanName ?? "")"
                    }
                    self.durationLabel.text = "\((response.object?.SubscriptionDays ?? 0)+(response.object?.TrialDays ?? 0))" + " Days"
                    self.planFeeLabel.text = "$ \(response.object?.Amount ?? 0)"
                    self.taxLabel.text = "$ \(response.object?.Tax ?? 0)"
                    self.totalAmountLabel.text = "$ \(response.object?.TotalPlanPrice ?? 0)"
                    self.discountLabel.text = "$ \(response.object?.Discount ?? 0)"
                    self.totalPrice = "\(response.object?.TotalPlanPrice ?? 0)"
                    self.tax = "$ \(response.object?.Tax ?? 0)"
                    self.createdOn = self.getFormattedDate(strDate: response.object?.startdate ?? "", currentFomat: "MMM dd, yyyy", expectedFromat: "yyyy-MM-dd")
                    
                    
                    // Set up Table view Value
                    
                    
                    self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.PlanName.localize(), Description: self.planLabel.text))
                    self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.duration.localize(), Description: self.durationLabel.text))
                    self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.PlanFee.localize(), Description: self.planFeeLabel.text))
                    
                    if /response.object?.Discount != 0{
                        self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.PlanDiscount.localize(), Description: self.discountLabel.text))
                    }
                    
                    self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.tax.localize(), Description: self.tax))
                    self.PlanDetailsArr.append(PlanDetails(title: SubscriptionScreenText.totalamount.localize(), Description: self.totalAmountLabel.text))
                    self.planDetailsTblVw.reloadData()
                    
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func paidDoctorPlans() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                        self.isSubscribed = true
                    }else{
                        self.isSubscribed = false
                    }
                case .failure:
                    self.isSubscribed = false
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func cancelSubscriptionPlan() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)", "RazorPaySubscriptionId": RazorPaySubscriptionId]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.cancelSubscription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? "")){
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)){
                        NavigationHandler.popTo(DoctorDashBoardVC.self)
                    }
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func buyPlan() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)","SubcriptionTypeId": "\(self.object?.SubscriptionPlansMaster?.id ?? 0)","PlanName": self.object?.SubscriptionPlansMaster?.subscriptionPlanName ?? "", "TotalAmount": self.totalPrice,"Tax":self.tax,"Discount": "0","CreatedOn": self.createdOn,"TotalPlanPrice": self.totalPrice,
                          "DisplayOrder": self.displayOrder, "PlanDuration": "\(object?.PlanDuration ?? 0)" ,"RazorPayPlanId": self.object?.SubscriptionPlansMaster?.razorPayPlanID ?? "","ProviderId": "\(Authentication.customerGuid!)"] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.buyplan(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    if response.message ?? "" == SubscriptionScreenText.incompletePurchase.localize(){
                        NavigationHandler.pushTo(.subscriptionPaymentVC)
                    }
                    else {
                        AlertManager.showAlert(type: .custom(response.message ?? "")){
                            NavigationHandler.popTo(DoctorDashBoardVC.self)
                        }
                        
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)){
                        NavigationHandler.pop()
                    }
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapPay(_ sender: Any) {
        if isSubscribed{
            self.subscriptionUpgradeAPI(PlanId: "\(object?.SubscriptionPlansMaster?.id ?? 0)")
        }else{
            self.paymentContext?.delegate = self
            self.paymentContext?.presentPaymentOptionsViewController()
        }
    }
    
    func subscriptionUpgradeAPI(PlanId : String){
        let queryItems = ["CustomerEmail":Authentication.customerEmail ?? "","PlanId": PlanId] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.subscriptionUpgradeAPI(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? "")){
                        
                        if /Authentication.profileComplete {
                            NavigationHandler.popTo(SubscribedPlanDetailsVC.self)
                        }else{
                            // When Profile is InComplete
                         //   NotificationCenter.default.post(name: .showBuySub, object: nil)
                            NavigationHandler.pushTo(.welcome)

                        }
                        
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
}
extension PlanCheckoutDetailsVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if paymentContext.selectedPaymentOption != nil && isSetShipping{
            print(paymentContext)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                paymentContext.presentShippingViewController()
            }
        }
        if paymentContext.selectedShippingMethod != nil && !isSetShipping {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.paymentContext?.requestPayment()
            }
        }
    }
    func subscriptionCallbackAPI(paymentMethodId : String){
        let queryItems = ["CustomerEmail":Authentication.customerEmail ?? "" ,"PaymentMethodId":paymentMethodId,"PlanId": "\(self.object?.SubscriptionPlansMaster?.id ?? 0)"] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.subscriptionCallbackAPI(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? "")){

                        
                        if /Authentication.profileComplete {
                            NavigationHandler.pushTo(.drPlanDetails("2"))
                        }else{
                            // When Profile is InComplete
                           // NotificationCenter.default.post(name: .showBuySub, object: nil)
                            
                            NavigationHandler.pushTo(.welcome)
                        }
                        
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        isSetShipping = false
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        /*let fedEx = PKShippingMethod()
         fedEx.amount = 5.99
         fedEx.label = "FedEx"
         fedEx.detail = "Arrives tomorrow"
         fedEx.identifier = "fedex"*/
        
        if address.country == "US" {
            //  completion(.valid, nil, [upsGround, fedEx], upsGround)
            completion(.valid, nil, [upsGround], upsGround)
        }
        else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("didFailToLoadWithError")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        print("paymentMethodId \(paymentResult.paymentMethod?.stripeId ?? "")")
        self.subscriptionCallbackAPI(paymentMethodId: paymentResult.paymentMethod?.stripeId ?? "")
        print("payment context")
        
        MyAPIClient.sharedClient.createPaymentIntent(amount: (Double(paymentContext.paymentAmount+Int((paymentContext.selectedShippingMethod?.amount)!))), currency: "usd") { (response) in
            switch response {
            case .success(let clientSecret):
                // Assemble the PaymentIntent parameters
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                paymentIntentParams.paymentMethodParams = paymentResult.paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        print("succeeded")
                        // Your backend asynchronously fulfills the customer's order, e.g. via webhook
                        completion(.success, nil)
                    case .failed:
                        print(" failed succeeded")
                        completion(.error, error) // Report error
                    case .canceled:
                        print(" cancele ssucceeded")
                        completion(.userCancellation, nil) // Customer cancelled
                    @unknown default:
                        print(" default succeeded")
                        completion(.error, nil)
                    }
                }
            case .failure(let error):
                print("faileur succeeded")
                completion(.error, error) // Report error from your API
                break
            }
        }
        
        print("didCreatePaymentResult")
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("didFinishWith")
    }
}


extension PlanCheckoutDetailsVC : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PlanDetailsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlandetailsTVC", for: indexPath as IndexPath) as! PlandetailsTVC
        
        let commentDic : PlanDetails = self.PlanDetailsArr[indexPath.row]
        
        let finalStr = /commentDic.title  + /commentDic.Description
        
        let string = NSMutableAttributedString(string: finalStr)
        if #available(iOS 13.0, *) {
            string.setColorForText(/commentDic.title, with: .label, font: UIFont(name:"HelveticaNeue", size: 16.0)! )
        } else {
            // Fallback on earlier versions
            string.setColorForText(/commentDic.title, with: .black, font: UIFont(name:"HelveticaNeue", size: 16.0)! )
        }
        if #available(iOS 13.0, *) {
            string.setColorForText(/commentDic.Description, with: .label, font: UIFont(name: "HelveticaNeue", size: 16.0)!)
        } else {
            // Fallback on earlier versions
            string.setColorForText(/commentDic.Description, with: .black, font: UIFont(name: "HelveticaNeue", size: 16.0)!)
        }
        cell.planLabelTxt.attributedText = string
        
        //cell.planLabelTxt.text = /commentDic.title + " " + /commentDic.Description
        
        if ((indexPath.row % 2) != 0) {
            cell.contentView.backgroundColor = UIColor.clear
        }else{
            if #available(iOS 13.0, *) {
                cell.contentView.backgroundColor = UIColor.systemGray5
            } else {
                cell.contentView.backgroundColor = UIColor.gray
            }
        }
        
        return cell
    }
    
    
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor , font : UIFont ) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
    }
}
