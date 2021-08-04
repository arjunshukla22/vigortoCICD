//
//  ConfirmInsurenceDocInfoVC.swift
//  SmileIndia
//
//  Created by Arjun  on 03/08/21.
//  Copyright © 2021 Na. All rights reserved.
//

import UIKit

class ConfirmInsurenceDocInfoVC: UIViewController {
    
    var objectApt: Appointment?
    
    var callback: (() -> Void)?
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var queLbl: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        SetupUI()
    }
    
    func SetupUI() {
        
        let message = AppointmentScreenTxt.InsurencePlanName.localize() + "\(self.objectApt?.InsurancePlanName ?? "")"
        
        msgLbl.text = message
        
        // Image
        imgVw.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)" + "\(self.objectApt?.InsuranceCardPic ?? "")")!, placeholderImage: UIImage.gif(name: "insurance_loader"))
        
        queLbl.text  = AppointmentScreenTxt.confirmAppointementWithInsurence.localize()
    }
    
    

    @IBAction func hideBackVwAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ViewFullAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.callback?()
        }
    }
}

