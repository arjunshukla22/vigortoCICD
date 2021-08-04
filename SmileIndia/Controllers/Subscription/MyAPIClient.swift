//
//  MyAPIClient.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 15/12/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
import Stripe

class MyAPIClient: NSObject,STPCustomerEphemeralKeyProvider {
    
    enum APIError: Error {
            case unknown

            var localizedDescription: String {
                switch self {
                case .unknown:
                    return "Unknown error"
                }
            }
        }

    static let sharedClient = MyAPIClient()
    
    var baseURLString: String? = "https://api.stripe.com/v1/"
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
   // let baseURL = http://vigorto.com:82
    /*func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
      // Create a EphemeralKey as soon as the view loads

        let parameters = "{\n    \"Email\":\"vishal.pusha@gmail.com\",\n    \"ApiVersion\":\"2020-03-02\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://vigorto.com/Customer/GenerateEphemeralKey")!,timeoutInterval: Double.infinity)
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
           // self.paymentIntentClientSecret = clientSecret
        }

        task.resume()

    }*/
 /*   func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock)
      
    {
      var request = URLRequest(url: URL(string: "http://vigorto.com/Customer/GenerateEphemeralKey?Email=\(Authentication.customerEmail ?? "")&ApiVersion=\(apiVersion)")!,timeoutInterval: Double.infinity)

      request.httpMethod = "POST"


     let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let response = response as? HTTPURLResponse,
           response.statusCode == 200,
           let data = data,
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            // let clientSecret = json?["clientSecret"] as? String
        completion(json, nil)
        else {
               let message = error?.localizedDescription ?? "Failed to decode response from server."
               return
         }
         
         completion(json, nil)
        print("error")
        // print("Created PaymentIntent")
        // self.paymentIntentClientSecret = clientSecret
     }

     task.resume()

    }*/
      
 func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock)
    
  {
    var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Customer/GenerateEphemeralKey?Email=\(Authentication.customerEmail ?? "")&ApiVersion=\(apiVersion)")!,timeoutInterval: Double.infinity)


    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
          
             let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
          //  print(json["Result"] as! String,json)
            let stringToParse = json["Result"] as? String ?? ""
            if let json1 = stringToParse.data(using: String.Encoding.utf8){
                  if let jsonData = try JSONSerialization.jsonObject(with: json1, options: .allowFragments) as? [AnyHashable:Any]{
                      print(jsonData)
                    completion(jsonData, nil)
                  }}
         //   completion(json["Result"] as? String, nil)
         } catch {
             print("error")
            completion(nil, error)
         }
    }
   
    task.resume()
    
  }
    
    class func createCustomer(){
        
        var customerDetailParams = [String:String]()
        customerDetailParams["email"] = "tes675t@gmail.com"
        customerDetailParams["phone"] = "8888888888"
        customerDetailParams["name"] = "test"

    }
    func createPaymentIntent(amount:Double,currency:String, completion: @escaping ((Result<String, Error>) -> Void)) {
      
        let parameters = "{\n    \"amount\":100,\n    \"currency\":\"INR\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.stripe.com/v1/payment_intents")!,timeoutInterval: Double.infinity)
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
            
           // completion(json, nil)
            completion(.success(json!["clientSecret"]! as! String))
            print("Created PaymentIntent")
           // self.paymentIntentClientSecret = clientSecret
        }

        task.resume()

          }
      //func createPaymentIntent(amount:Double,currency:String,customerId:String,completion:@escaping (Result<String,Error>)->Void){
         
          
  //}
    
    
  /*  func createPaymentIntent(amount:Double,currency:String, completion: @escaping ((Result<String, Error>) -> Void)) {
            let url = self.baseURL.appendingPathComponent("payment_intents")
          //  var params: [String: Any] = [
            //    "metadata": [
                  //  example-mobile-backend allows passing metadata through to Stripe
              //      "payment_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB"
              //  ]
           // ]
//            params["products"] = products.map({ (p) -> String in
//                return p.emoji
//            })
         //   if let shippingMethod = shippingMethod {
          //      params["shipping"] = shippingMethod.identifier
          //  }
//            params["country"] = country
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data,
                    let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String: Any]??),
                    let secret = json?["secret"] as? String else {
                        completion(.failure(error ?? APIError.unknown))
                        return
                }
                completion(.success(secret))
                print(json!)
            })
            task.resume()
        }
    //func createPaymentIntent(amount:Double,currency:String,customerId:String,completion:@escaping (Result<String,Error>)->Void){
       
        
//}
}
*/
}
