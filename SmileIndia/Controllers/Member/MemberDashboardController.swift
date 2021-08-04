
//
//  MemberDashboardController.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class MemberDashboardController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Hi \(Authentication.customerName ?? "") " 
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapDoctorProfile(_ sender: Any) {
        NavigationHandler.pushTo(.memberProfile)
    }
    
    @IBAction func didTapVerifyMembership(_ sender: Any) {
        NavigationHandler.pushTo(.seeMembership)
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
        NavigationHandler.pushTo(.memberChangePassword)
    }
    @IBAction func didTapAppointments(_ sender: Any) {
         NavigationHandler.pushTo(.appointmentList("0"))
    }
   
    @IBAction func didTapFamilyMember(_ sender: Any) {
        NavigationHandler.pushTo(.familyMember)
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            Authentication.clearData()
            NavigationHandler.logOut()
        }
    }
    
    
}
