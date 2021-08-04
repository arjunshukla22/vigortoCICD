//
//  ContactUsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 12/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class ContactUsVC: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var enquiryTV: UITextView!
    @IBOutlet weak var phoneNumBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = "v\(/appVersion?.toDouble())"
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        phoneNumBtn.setTitle("+1 (844) 844 6786  \n (\(ContactUsScreenTxt.tollFree.localize()))", for: .normal)
        phoneNumBtn.setTitleColor(.white, for: .normal)
        phoneNumBtn.titleLabel?.lineBreakMode = .byWordWrapping
        phoneNumBtn.titleLabel?.numberOfLines = 2
        phoneNumBtn.titleLabel?.textAlignment = .center
      //  nameTF.text = Authentication.customerName
       // emailTF.text = Authentication.customerEmail
        
    }
    @IBAction func didTapMail(_ sender: Any) {
        let appURL = URL(string: "mailto:support@vigorto.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
    
    @IBAction func didTapcall(_ sender: Any) {
        guard let number = URL(string: "tel://" + ("+18448446786")) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapPhone(_ sender: Any) {
        guard let number = URL(string: "tel://" + ("+18448446786")) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func didtapEmail(_ sender: Any) {
        let appURL = URL(string: "mailto:support@vigorto.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
    
    /*  @IBAction func didtapSubmit(_ sender: Any) {
        if isValidEnquiry(){
            enquiry()
        }
    }
    
  
  func enquiry()  {
        let queryItems = ["Name": nameTF.text!,"Email": emailTF.text!,"Enquiry":enquiryTV.text] as [String : Any]

        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.contactUs(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom("Your enquiry has been successfully submitted."), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.pop()
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }

    
    func isValidEnquiry() -> Bool {

        if nameTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom("Enter Your Name."))
            return false
        } else if nameTF.text!.count < 2{
            AlertManager.showAlert(type: .custom("Name should not less than two characters"))
            return false
        }else if emailTF.text!.isEmpty{
            AlertManager.showAlert(type: .custom("Enter Email."))
            return false
        }else if !(emailTF.text?.isValidEmail() ?? false) {
            AlertManager.showAlert(type: .custom("Incorrect Email."))
            return false
        }else if enquiryTV.text.isEmpty{
            AlertManager.showAlert(type: .custom("Enter Enquiry."))
            return false
        }

        return true
    }*/
}
