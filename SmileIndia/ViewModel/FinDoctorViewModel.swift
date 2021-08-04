//
//  FinDoctorViewModel.swift
//  SmileIndia
//
//  Created by Na on 24/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
import UIKit

class FindDoctorViewModel : NSObject {
    
    var speciality = [List]()
    var states = [List]()
    var cities = [List]()
    var country = [List]()
  
    func getSpecialities(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
       // activityIndicator.showLoaderOnWindow()
        WebService.getSpeciality(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
            //    activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.speciality = user
                        self.getCity(){
                            completion?()
                       }
                        self.getState("1"){
                            completion?()
                        }
                      
                    } else {
                        AlertManager.showAlert(type: .custom(response.message ?? ""))
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
           //     self.getTopMostViewControllerForNSObject()!.view.activityStopAnimating()
            }
        }
    }
    
    func getCountry(completion: (()->())?){
           let queryItems = ["AuthKey": Constants.authKey]
        //   activityIndicator.showLoaderOnWindow()
           WebService.GetCountries(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
         //          activityIndicator.hideLoader()
                   switch result {
                   case .success(let response):
                       if let user = response.objects {
                           self.country = user
                           completion?()
                       } else {
                           AlertManager.showAlert(type: .custom(response.message ?? ""))
                       }
                   case .failure(let error):
                       AlertManager.showAlert(type: .custom(error.message))
                   }
               }
           }
       }
     func getState(_ countryId : String,completion: (()->())?){
         let queryItems = ["AuthKey": Constants.authKey, "CountryId": countryId]
       //  activityIndicator.showLoaderOnWindow()
         WebService.getState(queryItems: queryItems) { (result) in
             DispatchQueue.main.async {
        //         activityIndicator.hideLoader()
                 switch result {
                 case .success(let response):
                     if let user = response.objects {
                         self.states = user
                         completion?()
                     } else {
                         AlertManager.showAlert(type: .custom(response.message ?? ""))
                     }
                 case .failure(let error):
                     AlertManager.showAlert(type: .custom(error.message))
                 }
             }
         }
     }
    func getCity(_ stateId : String, completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey, "StateId": stateId]
     //   activityIndicator.showLoaderOnWindow()
        WebService.getCity(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
      //          activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.cities = user
                        completion?()
                    } else {
                        AlertManager.showAlert(type: .custom(response.message ?? ""))
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    
    func getCity(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
      //  activityIndicator.showLoaderOnWindow()

        WebService.getAllCity(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
        //        activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.cities = user
                        completion?()
                    } else {
                        AlertManager.showAlert(type: .custom(response.message ?? ""))
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }

        }
    }

}
