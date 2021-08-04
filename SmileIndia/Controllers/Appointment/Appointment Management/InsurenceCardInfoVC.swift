//
//  InsurenceCardInfoVC.swift
//  SmileIndia
//
//  Created by Arjun  on 03/08/21.
//  Copyright © 2021 Na. All rights reserved.
//

import UIKit

class InsurenceCardInfoVC: UIViewController {
    

    var objectApt: Appointment?
    
    var callback: ((_ obj: Appointment) -> Void)?
    
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        SetupUI()
    }
    
    func SetupUI() {
        
        let message = Authentication.customerType == EnumUserType.Customer ? AppointmentScreenTxt.memberInsurence.localize() + "\((self.objectApt?.InsurancePlanName ?? "").uppercased())" : AppointmentScreenTxt.memberInsurence.localize() + "\((self.objectApt?.InsurancePlanName ?? "").uppercased())"
        
        msgLbl.text = message
        
        // Image
        imgVw.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)" + "\(self.objectApt?.InsuranceCardPic ?? "")")!, placeholderImage: UIImage.gif(name: "insurance_loader"))
    }
    
    

    @IBAction func hideBackVwAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ViewFullAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.callback?(self.objectApt!)
        }
    }
}
