//
//  Appointment.swift
//  SmileIndia
//
//  Created by Na on 09/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
class AppointmentViewModel : NSObject {
    
    var days = [String]()
    var time = [String]()
    
    func getDays(completion: (()->())?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let queryItems = ["PatientId": Authentication.customerId ?? ""]
     //   activityIndicator.showLoaderOnWindow()
        WebService.getNextSevenDaysDates(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
     //           activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objectString {
                        self.days = user
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
    
    func getTime(_ queryItems: [String: Any], completion: (()->())?){
     //   activityIndicator.showLoaderOnWindow()
        WebService.getBookAppointmentTiming(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
      //          activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let user = response.objectString {
                        self.time = user
                        completion?()
                    } else {
                        self.time = []
                        completion?()
                    }
                case .failure:
                    self.time = []
                    completion?()
//                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
}
