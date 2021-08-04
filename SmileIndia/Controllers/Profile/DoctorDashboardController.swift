//
//  DoctorDashboardController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class DoctorDashboardController: UIViewController {
    
    var doctor: DoctorData?


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       // profileLabel.text = Authentication.customerType == "Hospital" ? "HOSPITAL\nPROFILE" : "DOCTOR\nPROFILE"
        profileLabel.text = "MY PROFILE"
        nameLabel.text = "Hi \(Authentication.customerName ?? "") " 
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }

    @IBAction func didTapDoctorProfile(_ sender: Any) {
        if Authentication.customerType == "Hospital" {
            AlertManager.showAlert(type: .custom("Please visit https://www.smileindia.com to manage your profile."))
            return
        }
        NavigationHandler.pushTo(.doctorAccount)
    }
    
    @IBAction func didTapVerifyMembership(_ sender: Any) {
       // NavigationHandler.pushTo(.membership)
        NavigationHandler.pushTo(.home)

    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
         NavigationHandler.pushTo(.changePassword)
    }
    @IBAction func didTapAppointments(_ sender: Any) {
        NavigationHandler.pop()

      //  NavigationHandler.pushTo(.appointmentList)
    }
    @IBAction func didTapRatings(_ sender: Any) {
        NavigationHandler.pushTo(.ratingList)
    }
    @IBAction func didTapLogout(_ sender: Any) {
        AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            Authentication.clearData()
            NavigationHandler.logOut()
        }
    }
    
 
}
