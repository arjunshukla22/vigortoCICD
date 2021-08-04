//
//  SignupViewModel.swift
//  SmileIndia
//
//  Created by user on 13/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
class SignupViewModel : NSObject {
    var titles =  [List]()
    var gender =  [List]()
    var speciality = [List]()
    var degree =  [List]()
    var states =  [List]()
    var cities =  [List]()
    var country = [List]()
    var socioTags = [List]()
   
    var businessHours : BusinessHour?
    var timezoneModel = [TimeZoneModel]()
   
    
    func hitApis(completion: (()->())?){
        getTitles{
            completion?()
        }
    }
    
    func getTitles(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
        WebService.getTitle(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
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
        WebService.getGender(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.gender = user
                        self.getSpecialities{
                            completion?()
                        }
                        
                    } else {
                        print(response.message)
                        
                    }
                case .failure(let error):
                    print(error.message)
                    //                    self.showError(message: error.message) }
                }
            }
        }
    }
  
    func getTimeZone(completion: (()->())?){
       
           let queryItems = ["":""]
           WebService.GetAllTimeZoneus(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
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
    func getTag(completion: (()->())?){
        let queryItems = ["Loginkey": "Z3VyZGVlcC5zaW5naEBzbWlsZWluZGlhLmNvbTpTaW5naEAxMjM=", "IsApp": true] as [String : Any]
        WebService.Gettags(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.socioTags = user
                        self.getDegree(){
                            completion?()
                        }
                        
                    } else {
                        print(response.message)
                        
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
        WebService.getSpeciality(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.objects {
                        self.speciality = user
                        self.getDegree(){
                            completion?()
                        }
                    } else {
                        AlertManager.showAlert(type: .custom(response.message ?? ""))
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    func getDegree(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
        WebService.getDegree(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
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
    func getCity(_ stateId : String, completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey, "StateId": stateId]
        WebService.getCity(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
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
    func getState(_ countryId : String,completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey, "CountryId": countryId]
        WebService.getState(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
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
    func getCountry(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
        WebService.GetCountries(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
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
    
    func getBusinessHours(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
        WebService.getBusinessHours(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.businessHours = user
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
    func getRelationShip(completion: (()->())?){
        let queryItems = ["AuthKey": Constants.authKey]
        WebService.getBusinessHours(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.businessHours = user
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
