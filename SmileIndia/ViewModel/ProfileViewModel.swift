//
//  ProfileViewModel.swift
//  SmileIndia
//
//  Created by Na on 03/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation

class ProfileViewModel : NSObject {
    
    var arrayProfile = ["DOCTOR PROFILE", "VERIFY MEMBERSHIP", "CHANGE PASSWORD", "APPOINTMENTS", "RATING"]
    var degree =  [List]()
    var country = [List]()
    var states =  [List]()
    var cities =  [List]()
    var titles =  [List]()
    var gender =  [List]()
    var speciality = [List]()
    var timezoneModel = [TimeZoneModel]()
    
func getDegree(completion: (()->())?){
    let queryItems = ["AuthKey": Constants.authKey]
 //   activityIndicator.showLoaderOnWindow()
    WebService.getDegree(queryItems: queryItems) { (result) in
        DispatchQueue.main.async {
 //           activityIndicator.hideLoader()
            switch result {
            case .success(let response):
                if let user = response.objects {
                    self.degree = user
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
    func getTimeZone(completion: (()->())?){
             let queryItems = ["":""]
      //       activityIndicator.showLoaderOnWindow()
             WebService.GetAllTimeZoneus(queryItems: queryItems) { (result) in
                 DispatchQueue.main.async {
    //                 activityIndicator.hideLoader()
                     switch result {
                     case .success(let response):
                       
                      self.timezoneModel = response.objects ?? []
                             completion?()
                      
                       
                     case .failure(let error):
                         AlertManager.showAlert(type: .custom(error.message))
                     }
                 }
             }
         }
        
       func getCountry(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
    //    activityIndicator.showLoaderOnWindow()
        WebService.GetCountries(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
    //            activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.country = user.filter({ $0.Text != "" })
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
     //   activityIndicator.showLoaderOnWindow()
        WebService.getState(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
     //           activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.states = user.filter({ $0.Text != "" })
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
      //  activityIndicator.showLoaderOnWindow()
        WebService.getCity(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
       //         activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.cities = user.filter({ $0.Text != "" })
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
    func getTitles(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
     //   activityIndicator.showLoaderOnWindow()
        WebService.getTitle(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
     //           activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.titles = user
                        self.getGender{
                            completion?()
                        }
                        
                    } else {
                        print(response.message ?? "")
                        
                    }
                case .failure(let error):
                    print(error.message)
                    //                    self.showError(message: error.message) }
                }
            }
        }
    }
    func getGender(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
     //   activityIndicator.showLoaderOnWindow()
        WebService.getGender(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
     //           activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.gender = user
                        self.getSpecialities{
                            completion?()
                        }
                        
                    } else {
                        print(response.message ?? "")
                    }
                case .failure(let error):
                    print(error.message)
                    //                    self.showError(message: error.message) }
                }
            }
        }
    }
    func getSpecialities(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
      //  activityIndicator.showLoaderOnWindow()
        WebService.getSpeciality(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
      //          activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.speciality = user
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
