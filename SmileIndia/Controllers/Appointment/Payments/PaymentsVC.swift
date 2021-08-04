//
//  PaymentsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 14/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Razorpay

import Stripe

class PaymentsVC: UIViewController {
    
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var cnsltFeeLabel: UILabel!
    @IBOutlet weak var gstLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var vgStackView: UIStackView!
    @IBOutlet weak var vgLabel: UILabel!
    @IBOutlet weak var vgCreditsLabel: UILabel!
    @IBOutlet weak var feeDisplayLabel: UILabel!
    @IBOutlet weak var btnPayLater: UIButton!
    
    var date = ""
    var time = ""
    var orderId = ""
    var apntType = ""
    var cardId = ""
    var plan_name = ""
    var doctor: Doctor?
    
    private var razorpay:RazorpayCheckout?

    var member: Member?
    
    var appointmentCheckOut: AppointmentCheckOut?
    
    @IBOutlet weak var btnMakePayment: UIButton!
    
    var paymentIntentClientSecret: String?

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        setupUI()
        
     //  razorpay = RazorpayCheckout.initWithKey("rzp_test_E3jguIxtnrkr0E", andDelegateWithData: self)
     //  razorpay = RazorpayCheckout.initWithKey("rzp_live_7VqFi2h6B2gzWy", andDelegateWithData: self)
        getprofile()
        
        if plan_name == ""{
            btnMakePayment.setTitle(PaymentScreenTxt.makePayment.localize(), for: .normal)
            vgStackView.isHidden = false
        }else{
            btnMakePayment.setTitle(PaymentScreenTxt.Confirm.localize(), for: .normal)
            vgStackView.isHidden = true
            
        }
    }
    
    func setupUI() -> Void {
        self.doctorLabel.text = doctor?.ProviderName
        if let address1 = doctor?.Address1?[0] {
            self.clinicLabel.text = address1.HospitalName ?? ""
        }
        self.dateLabel.text = self.getFormattedDate(strDate: date.components(separatedBy: " ").last ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
        self.dayLabel.text = self.getFormattedDate(strDate: date.components(separatedBy: " ").first ?? "", currentFomat: "EEE", expectedFromat: "EEEE")
        self.timeLabel.text = time
       
        self.totalAmountLabel.text = "$ \(self.appointmentCheckOut?.TotalAmount ?? 0)"
        self.gstLabel.text = "$ \(self.appointmentCheckOut?.TaxAmount ?? 0)"
        self.typeLabel.text = self.apntType == "1" ? PaymentScreenTxt.InPerson.localize():PaymentScreenTxt.EAppointment.localize()
        
        let vgc = self.appointmentCheckOut?.SmileIndiaCredits ?? 0
        let cp =  self.appointmentCheckOut?.ConsultationAmount ?? 0
        if vgc > cp || vgc == cp {
            vgStackView.isHidden = false
            vgCreditsLabel.isHidden = false
            vgLabel.isHidden = false
            self.vgCreditsLabel.text = "- $ \(self.appointmentCheckOut?.SmileIndiaCredits ?? 0)"
           }
        else {
            vgStackView.isHidden = true
            vgCreditsLabel.isHidden = true
            vgLabel.isHidden = true
         
        }
       
        if cardId == ""{
            self.feeDisplayLabel.text = PaymentScreenTxt.Consultaionfee.localize()
            self.cnsltFeeLabel.text = "$ \(self.appointmentCheckOut?.ConsultationAmount ?? 0)"
            
            self.btnPayLater.isHidden = (self.apntType == "2")
        }else{
            self.feeDisplayLabel.text = PaymentScreenTxt.Insurence.localize()
            self.cnsltFeeLabel.text = plan_name
            self.btnPayLater.isHidden = true
        }
    }
    
    func getprofile(){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getMemberProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let member = response.object {
                        self.member = member
                    }
                case .failure(let error):
                    print(error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    internal func showPaymentForm(){

        let options: [String:Any] = [
                  //  "amount": (appointmentFee)*100, //This is in currency subunits. 100 = 100 paise= INR 1.
                 //   "currency": "INR",//razorpay support more that 92 international currencies.
                    "description": "Appointment booking fee.",
                    "image": UIImage(named: "welcomeLogo.png")!,
                    "name": "SmileIndia",
                    "order_id": "\(orderId)" ,// Order ID returned by Razorpay
                    "prefill": [
                        "contact": member?.Phone,
                        "email": member?.Email
                    ],
                    "theme": [
                        "color": "#61bb49"
                    ]
                ]
        razorpay?.open(options)
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    @IBAction func didtapMakepayement(_ sender: Any) {
      //  showPaymentForm()
      //  self.loadStripe()
        if cardId == "" {
            if vgCreditsLabel.isHidden == false{
                self.enableAppointmentWithoutPayment(type: "Appointment")
                
            }
            else{
            let config = STPPaymentConfiguration.shared()
            config.requiredBillingAddressFields = .name
            let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
            viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
            }
           // NavigationHandler.pushTo(.stripeCheckout(self.appointmentCheckOut!))
        }else{
          
                self.enableAppointmentWithoutPayment(type: "Insurance")}
        
    }
    
    @IBAction func didtapPayLater(_ sender: Any) {
        self.enableAppointmentWithoutPayment(type: "PayLater")
    }
    
    func enableAppointmentWithoutPayment(type:String)  {
        let queryItems = ["Id": self.appointmentCheckOut?.AppointmentId ?? 0 ,"Type":type] as [String : Any]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.enableAppointmentWithoutPayment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom(PaymentScreenTxt.AptBookedSucess.localize())){
                        NavigationHandler.pushTo(.appointmentList("1"))
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func loadStripe() -> Void {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .postalCode
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.apiClient = StripeAPIClient()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }
    @IBAction func didtapCancel(_ sender: Any) {
        NavigationHandler.pop()
    }
    

}


extension PaymentsVC: RazorpayPaymentCompletionProtocol,RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print(response! as NSDictionary)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        let dict = response! as NSDictionary
        print(dict)
        print(dict["razorpay_order_id"]!)
        print(dict["razorpay_payment_id"]!)
        print(dict["razorpay_signature"]!)
        print(payment_id)
savePaymentInformation(orderID: "\(dict["razorpay_order_id"]!)", paymentID: "\(dict["razorpay_payment_id"]!)", signature: "\(dict["razorpay_signature"]!)")
    }
    
    
    public func onPaymentError(_ code: Int32, description str: String){
      AlertManager.showAlert(type: .custom(str))
    }

    public func onPaymentSuccess(_ payment_id: String){
        
        AlertManager.showAlert(type: .custom("\(PaymentScreenTxt.sucessPaymentID.localize()) \(payment_id)")){
            NavigationHandler.pushTo(.appointmentList("1"))
            
        }
    }
    
    
    func savePaymentInformation(orderID:String,paymentID:String,signature:String) -> Void {
        
        let queryItems = ["OrderId": orderID, "PaymentId": paymentID, "Signature": signature, "Type": "Appointment", "Id": "\(self.appointmentCheckOut?.AppointmentId ?? 0)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.savePaymentInformation(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    AlertManager.showAlert(type: .custom(PaymentScreenTxt.AptBookedSucess.localize())){
                      //  NavigationHandler.popTo(FindDoctorController.self)
                        NavigationHandler.pushTo(.appointmentList("1"))
                    }
                    print(response)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            self.view.activityStopAnimating()
            }
        }
    }

}


extension PaymentsVC: STPAddCardViewControllerDelegate ,STPAuthenticationContext{

    func startCheckout(completion: @escaping STPJSONResponseCompletionBlock) {
      // Create a PaymentIntent as soon as the view loads
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        let parameters = "{\n    \"amount\":\(self.appointmentCheckOut?.TotalAmount ?? 0),\n    \"currency\":\"USD\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Customer/CreatePaymentIntent")!,timeoutInterval: Double.infinity)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Nop.customer=89f055a3-c817-44f7-a53b-053c2e10bc06; Nop.customer=89f055a3-c817-44f7-a53b-053c2e10bc06", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async {
            guard let response = response as? HTTPURLResponse,
              response.statusCode == 200,
              let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json?["clientSecret"] as? String else {
                  let message = error?.localizedDescription ?? "Failed to decode response from server."
                    DispatchQueue.main.async {
                        AlertManager.showAlert(type: .custom(message))
                    }
                  return
            }
            
            completion(json, nil)
                print("Created PaymentIntent")
                self.paymentIntentClientSecret = clientSecret
            }
        }

        task.resume()

    }
    //MARK:- STPAdd Card Controller Delegate
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        self.dismiss(animated: true, completion: nil)
        self.startCheckout { (paymentIntentResponse, error) in
                 if let error = error {
                     print(error)
                     return
                 }else {
                    guard let responseDictionary = paymentIntentResponse as? [String: AnyObject] else {
                        print("Incorrect response")
                        return
                    }
                    let clientSecret = responseDictionary["clientSecret"] as! String
                    print("here paymentMethodId ;- \(paymentMethod.stripeId)")
                    print(clientSecret)
                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                    paymentIntentParams.paymentMethodId = paymentMethod.stripeId
                    
                    STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                        print("Reason :- "+"\(error?.localizedDescription ?? "")" )
                        var resultString = ""
                        switch (status) {
                        case .canceled:
                            resultString = "Payment canceled"
                            self.view.activityStopAnimating()
                            AlertManager.showAlert(type: .custom("Payment canceled"+"\nReason :- "+"\(error?.localizedDescription ?? "")"))
                        case .failed:
                            resultString = "Payment failed, please try a different card"
                            self.view.activityStopAnimating()
                            AlertManager.showAlert(type: .custom("Payment failed, please try a different card"+"\nReason :- "+"\(error?.localizedDescription ?? "")"))
                        case .succeeded:
                            resultString = "Payment successful"
                            self.savePaymentInformation(orderID: self.paymentIntentClientSecret ?? "" , paymentID: paymentIntent?.stripeId ?? "")
                        @unknown default:
                            break
                        }
                        print(resultString)
                    }
            }
        }
        

      //  self.dismiss(animated: true, completion: nil)
    }
    
    func savePaymentInformation(orderID:String,paymentID:String) -> Void {
        
        let queryItems = ["OrderId": orderID, "PaymentId": paymentID, "Type": "Appointment", "Id": "\(self.appointmentCheckOut?.AppointmentId ?? 0)"]
     //   self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.savePaymentInformation(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    AlertManager.showAlert(type: .custom(PaymentScreenTxt.AptBookedSucess.localize())){
                      //  NavigationHandler.popTo(FindDoctorController.self)
                        NavigationHandler.pushTo(.appointmentList("1"))
                    }
                    print(response)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            self.view.activityStopAnimating()
            }
        }
    }
    // MARK: STPAuthenticationContext Delegate
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
}


