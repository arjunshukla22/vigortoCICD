//
//  PrescriptionViewModel.swift
//  SmileIndia
//
//  Created by Arjun  on 15/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
import UIKit

class PrescriptionViewModel: NSObject {
    
    var templates = [PrescriptionTemplates]()

    func getPrescriptionTemplates(completion: (()->())?) {
        activityIndicator.showLoaderOnWindow()
        let queryItems = ["CustomerId": Authentication.customerId!]
        WebService.getPrescriptionTemplates(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
            activityIndicator.hideLoader()

                switch result {
                case .success (let response):
                    if let template = response.objects {
                        self.templates = template
                        completion?()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)){
                            NavigationHandler.pop()
                    }
              }
            }
        }
    }
}
