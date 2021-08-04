//
//  StripeCheckOutVC.swift
//  SmileIndia
//
//  Created by Arjun  on 28/09/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Stripe

class StripeCheckOutVC: UIViewController , STPAuthenticationContext {
    
    // MARK: UIViews
    var productStackView = UIStackView()
    var paymentStackView = UIStackView()
    var productImageView = UIImageView()
    var productLabel = UILabel()
    var payButton = UIButton()
    var paymentTextField = STPPaymentCardTextField()
    

    var paymentIntentClientSecret: String?
    
    var appointmentCheckOut: AppointmentCheckOut?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup UI (images, labels, debug text view)
        // Also setup STPPaymentCardTextField from Stripe-iOS
        setStatusBar(color: .themeGreen)
   //   createPaymentIntent()
        self.setupUI()
    }
    func savePaymentInformation(orderID:String,paymentID:String) -> Void {
        
        let queryItems = ["OrderId": orderID, "PaymentId": paymentID, "Type": "Appointment", "Id": "\(self.appointmentCheckOut?.AppointmentId ?? 0)"]
     //   self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.savePaymentInformation(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    AlertManager.showAlert(type: .custom("Your Appointment is booked successfully!")){
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
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    // MARK: UIView setup
    
    func setupUI() {
        setupProductImage()
        setupProductLabel()
        setupPaymentTextField()
        setupPayButton()

        self.productStackView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width-40, height: 300)
        self.productStackView.center.x = self.view.center.x
        self.productStackView.alignment = .center
        self.productStackView.axis = .vertical
        self.productStackView.distribution = .equalSpacing

        self.productStackView.addArrangedSubview(self.productImageView)
        self.productStackView.setCustomSpacing(10, after: self.productImageView)
        self.productStackView.addArrangedSubview(self.productLabel)
     //   self.view.addSubview(self.productImageView)
        self.view.addSubview(self.productStackView)

        self.paymentStackView.frame = CGRect(x: 0, y: 400, width: self.view.frame.width-40, height: 100)
        self.paymentStackView.center.x = self.view.center.x
        self.paymentStackView.alignment = .fill
        self.paymentStackView.axis = .vertical
        self.paymentStackView.distribution = .equalSpacing

        self.paymentStackView.addArrangedSubview(self.paymentTextField)
        self.paymentStackView.addArrangedSubview(self.payButton)
        
        self.view.addSubview(self.paymentStackView)
    }
    
    func setupProductImage() {
        self.productImageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 340, height: self.view.frame.width-100))
        self.productImageView.image = UIImage(named: "payment-card")
        self.productImageView.contentMode = .scaleAspectFit
    }
    func setupProductLabel() {
        self.productLabel.frame = CGRect(x: 20, y: 0, width: self.view.frame.width, height: 40)
        self.productLabel.text = ""
        self.productLabel.font = .boldSystemFont(ofSize: 20)
        self.productLabel.textAlignment = .left
    }
    func setupPaymentTextField() {
        self.paymentTextField.frame = CGRect(x: 0, y: 10, width: 330, height: 60)
        self.paymentTextField.postalCodeEntryEnabled = false
    }
    func setupPayButton() {
        self.payButton.frame = CGRect(x: 60, y: 480, width: 150, height: 50)
        self.payButton.setTitle("Pay", for: .normal)
        self.payButton.setTitleColor(UIColor.white, for: .normal)
        self.payButton.layer.cornerRadius = 5.0
        self.payButton.backgroundColor = .themeGreen
        self.payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
    }
    

    // MARK: Button Actions
    @objc func pay() {
        
        if paymentTextField.isValid{

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
                    
                    // Confirm the PaymentIntent using STPPaymentHandler
                    // implement delegates for STPAuthenticationContext

                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                    let paymentMethodParams = STPPaymentMethodParams(card: self.paymentTextField.cardParams, billingDetails: nil, metadata: nil)
                    paymentIntentParams.paymentMethodParams = paymentMethodParams
                    
                    STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                        
                        print("Reason :- "+"\(error?.localizedDescription ?? "")" )
                        print(self.paymentTextField.cardParams.cvc!, self.paymentTextField.cardParams.number! ,self.paymentTextField.cardParams.expMonth! ,self.paymentTextField.cardParams.expYear!)

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
                           self.savePaymentInformation(orderID: clientSecret , paymentID: paymentIntent?.stripeId ?? "")
                        @unknown default:
                            break
                        }
                        print(resultString)
                    }
                }
            }
        }else{
            AlertManager.showAlert(type: .custom("Please enter valid card details!"))
        }
        // make a POST request to the /create_payment_intent endpoint


    }
    
    func createPaymentIntent() -> Void {
        let queryItems = ["amount": "\(self.appointmentCheckOut?.TotalAmount ?? 0)", "currency": "USD","emailId":Authentication.customerEmail ?? ""]
        
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            WebService.createPaymentIntent(queryItems: queryItems) { (result) in
             DispatchQueue.main.async {
                    switch result {
                    case .success (let response):
                        print(response.object ?? "")
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                self.view.activityStopAnimating()
                }
            }
    }
    
    func startCheckout(completion: @escaping STPJSONResponseCompletionBlock) {
      // Create a PaymentIntent as soon as the view loads
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        let parameters = "{\n    \"amount\":\(self.appointmentCheckOut?.TotalAmount ?? 0),\n    \"currency\":\"USD\"\n}"
        let postData = parameters.data(using: .utf8)

        print(self.appointmentCheckOut?.TotalAmount ?? 0)

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
                  let message = error?.localizedDescription ?? "Error occured please try again."
                    DispatchQueue.main.async {
                        AlertManager.showAlert(type: .custom(message))
                    }
                  return
            }
            
            completion(json, nil)
              //  self.view.activityStopAnimating()
                print("Created PaymentIntent")
                self.paymentIntentClientSecret = clientSecret
            }
        }

        task.resume()

    }

    // MARK: STPAuthenticationContext Delegate
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }


}

