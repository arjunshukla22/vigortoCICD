//
//  StripeAPIClient.swift
//  SmileIndia
//
//  Created by Arjun  on 24/09/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
import Stripe

class StripeAPIClient: STPAPIClient, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return UIApplication.topViewController()!
    }
    
    var paymentIntentClientSecret: String?

    override func createPaymentMethod(with paymentMethodParams: STPPaymentMethodParams, completion: @escaping STPPaymentMethodCompletionBlock) {
        guard let card = paymentMethodParams.card, let billingDetails = paymentMethodParams.billingDetails else { return }
        
        // Generate a mock card model using the given card params
        var cardJSON: [String: Any] = [:]
        var billingDetailsJSON: [String: Any] = [:]
        cardJSON["id"] = "\(card.hashValue)"
        cardJSON["exp_month"] = "\(card.expMonth ?? 0)"
        cardJSON["exp_year"] = "\(card.expYear ?? 0)"
        cardJSON["last4"] = card.number?.suffix(4)
        billingDetailsJSON["name"] = billingDetails.name
        billingDetailsJSON["line1"] = billingDetails.address?.line1
        billingDetailsJSON["line2"] = billingDetails.address?.line2
        billingDetailsJSON["state"] = billingDetails.address?.state
        billingDetailsJSON["postal_code"] = billingDetails.address?.postalCode
        billingDetailsJSON["country"] = billingDetails.address?.country
        cardJSON["country"] = billingDetails.address?.country
        if let number = card.number {
            let brand = STPCardValidator.brand(forNumber: number)
            cardJSON["brand"] = STPCard.string(from: brand)
        }
        cardJSON["fingerprint"] = "\(card.hashValue)"
        cardJSON["country"] = "US"
        let paymentMethodJSON: [String: Any] = [
            "id": "\(card.hashValue)",
            "object": "payment_method",
            "type": "card",
            "livemode": true,
            "created": NSDate().timeIntervalSince1970,
            "used": false,
            "card": cardJSON,
           // "billing_details": billingDetailsJSON,
        ]

        let stripeCardParams = STPCardParams()
        stripeCardParams.number = card.number
        stripeCardParams.expMonth = card.expMonth as! UInt
        stripeCardParams.expYear = card.expYear as! UInt
        stripeCardParams.cvc = card.cvc
        
        
        STPAPIClient.shared().createToken(withCard: stripeCardParams) { (token: STPToken?, error: Error?) in
           // print("Printing Strip response:\(String(describing: token?.allResponseFields))\n\n")
         //   print("Printing Strip Token:\(String(describing: token?.tokenId))")
            if error != nil {
              //  print(error?.localizedDescription)
            }
            if token != nil{
             //   print("Transaction success! \n\nHere is the Token: \(String(describing: token!.tokenId))\nCard Type: \(String(describing: token!.card!.funding))\n\nSend this token or detail to your backend server to complete this payment.")
            }
        }

        let paymentMethod = STPPaymentMethod.decodedObject(fromAPIResponse: paymentMethodJSON)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion(paymentMethod, nil)
        }
        
        self.pay(card: paymentMethodParams)

    }
    
    func startCheckout(completion: @escaping STPJSONResponseCompletionBlock) {
      // Create a PaymentIntent as soon as the view loads

        let parameters = "{\n    \"amount\":100,\n    \"currency\":\"USD\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Customer/CreatePaymentIntent")!,timeoutInterval: Double.infinity)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Nop.customer=89f055a3-c817-44f7-a53b-053c2e10bc06; Nop.customer=89f055a3-c817-44f7-a53b-053c2e10bc06", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
              response.statusCode == 200,
              let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json?["clientSecret"] as? String else {
                  let message = error?.localizedDescription ?? "Failed to decode response from server."
                  return
            }
            
            completion(json, nil)

            print("Created PaymentIntent")
            self.paymentIntentClientSecret = clientSecret
        }

        task.resume()

    }
    
    @objc func pay(card :STPPaymentMethodParams) {
        // 1) [server-side] Create a PaymentIntent
        // 2) [client-side] Confirm the PaymentIntent
        
        // make a POST request to the /create_payment_intent endpoint

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
                let paymentMethodParams = STPPaymentMethodParams(card: card.card!, billingDetails: nil, metadata: nil)
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                    
                    var resultString = ""
                    
                    switch (status) {
                    case .canceled:
                        resultString = "Payment canceled"
                    case .failed:
                        resultString = "Payment failed, please try a different card"
                    case .succeeded:
                        print(paymentIntent)
                        AlertManager.showAlert(type: .custom("Payment successful but appointment not booked , work in progress!!! \n\n Payment Info :- \n \(paymentIntent!)")){
                          //  NavigationHandler.popTo(FindDoctorController.self)
                            NavigationHandler.pushTo(.appointmentList("1"))
                        }
                        resultString = "Payment successful"
                    @unknown default:
                        break
                    }
                    
                    print(resultString)
                }
            }
        }

    }
    
    
    

}

