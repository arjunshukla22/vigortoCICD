//
//  LoginViewController.swift
//  SmileIndia
//
//  Created by Na on 10/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import Localize

class LoginViewController: BaseViewController {
    
    var isSaveEmail = true
    
    @IBOutlet weak var remeberMeBtnOL: UIButton!
    
    @IBOutlet weak var swtchRemember: UISwitch!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
     var accountDetails = [AccountDetails]()
    var isSubscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        demo12@gmail.com:987654
//        ZGVtbzEyQGdtYWlsLmNvbTo5ODc2NTQ=
//        LIVE
//        pankaj246311@gmail.com
//        Password- a42xE
//        cGFua2FqMjQ2MzExQGdtYWlsLmNvbTphNDJ4RQ==
        //MEMBER LIVE
//        navsharma7321@gmail.com/qwerty
//        agmahi805@gmail.com
//        MqOb6
//        emailtextfield.text = "demo12@gmail.com"
//        passwordTextfield.text = "987654"
        
        hideKeyboardWhenTappedAround()
        
        emailtextfield.rightViewMode = UITextField.ViewMode.always
        emailtextfield.rightView = UIImageView(image: UIImage(named: "mail"))
        
     //   passwordTextfield.rightViewMode = UITextField.ViewMode.always
     //   passwordTextfield.rightView = UIImageView(image: UIImage(named: "lock"))
        
        swtchRemember.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        setStatusBar(color: .themeGreen)

        if Authentication.remember == "" {
            self.emailtextfield.text = ""
        }else
        {
            self.emailtextfield.text = Authentication.remember
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        passwordTextfield.text = ""
        remeberMeBtnOL.setImage(UIImage(named: "checkBoxApp"), for: .normal)
        NavigationHandler.hideNavigationBar()
    }
    
    @IBAction func didTapForgetPassword(_ sender: Any) {
        NavigationHandler.pushTo(.forgot)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapSkipStep(_ sender: Any) {
        NavigationHandler.pushTo(.homeViewController)
    }
    
    @IBAction func RembermeBtnAction(_ sender: Any) {
        
        isSaveEmail = !isSaveEmail
        print(isSaveEmail)
        
        if isSaveEmail {
            remeberMeBtnOL.setImage(UIImage(named: "checkBoxApp"), for: .normal)
        } else {
            remeberMeBtnOL.setImage(UIImage(named: "checkboxBlankApp"), for: .normal)
        }
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        self.view.endEditing(true)
        if isValid() {
            let queryItems = ["AuthKey": Constants.authKey,
                              "UserEmail": emailtextfield.text ?? "",
                              "Password": passwordTextfield.text ?? ""] as [String : Any]
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            WebService.loginUser(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if let user = response.object {
                           // if  self.swtchRemember.isOn{
                            
                            if self.isSaveEmail {
                                Authentication.authenticateUser(user, self.passwordTextfield.text ?? "", user.CustomerGuid ?? "", self.emailtextfield.text ?? "", /user.IscompleteProfile)
                            }else{
                                Authentication.authenticateUser(user, self.passwordTextfield.text ?? "", user.CustomerGuid ?? "", "", /user.IscompleteProfile)
                            }
                            self.saveToken(user.CustomerGuid ?? "")
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name("UserDidLoginNotification"), object: nil, userInfo: ["userId": user.email!])
                     //           NotificationCenter.default.post(name: NSNotification.Name("userPhone"), object: nil, userInfo: ["phone": user.phone!])

                            }
                            
                        } else { self.showError(message: response.message ?? "")  }
                    case .failure(let error):
                        self.showError(message: error.message) }
                    self.view.activityStopAnimating()
                }
            }
        }
    }
    
    func saveToken(_ uid: String) {
        let queryItems = ["CustomerUID": uid,
                          "DeviceToken": Authentication.deviceToken ?? "", "DeviceType": "I"] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.saveToken(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if Authentication.customerType == "Hospital" {
                        BaseNavigationController.sharedInstance.setRoot(.homeViewController)
                    }
                    else if Authentication.customerType == "Doctor"
                    {
                        if /Authentication.profileComplete {
                            // Call Paid Doctor Plan Apis
                            self.paidDoctorPlans(guid: /Authentication.customerGuid )
                        }else{
                            // When Profile is InComplete
                            NavigationHandler.pushTo(.doctorProfileOne)
                        }
                        
                    }else {
                        NavigationHandler.loggedIn()
                    }
                case .failure(let error):
                    self.showError(message: error.message) }
                
                    self.view.activityStopAnimating()
            }
        }
    }
    
    func paidDoctorPlans(guid:String) -> Void {
        let queryItems = ["CustomerGuid": guid]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
        DispatchQueue.main.async {
        switch result {
         case .success(let response):
             if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                self.isSubscribed = true
                BaseNavigationController.sharedInstance.setRoot(.appointmentList("0"))
             }else{
                self.isSubscribed = false
                let vc = UIStoryboard.init(name: "subscription", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC
                vc?.isComingFrom = "Login"
                self.navigationController?.pushViewController(vc!, animated: true)
               
             }
         case .failure:
            self.isSubscribed = false
               // BaseNavigationController.sharedInstance.setRoot(.homeViewController)
            
                self.isSubscribed = false
                let vc = UIStoryboard.init(name: "subscription", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC
                vc?.isComingFrom = "Login"
                self.navigationController?.pushViewController(vc!, animated: true)
            
            
            }
            self.view.activityStopAnimating()
              }
           }
        }
    
    @IBAction func didtapContactUs(_ sender: Any) {
        NavigationHandler.pushTo(.contactUs)
    }
    
    @IBAction func didTapCreateButton(_ sender: Any) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popOverVC, animated: true)
    }
}

extension LoginViewController {
    func isValid() -> Bool {
        guard let email = emailtextfield.text, let password = passwordTextfield.text else {return false}
        if email.isEmptyString() || !email.isValidEmail(){
            emailtextfield.becomeFirstResponder()
            AlertManager.showAlert(on: self, type: .custom(LoginScreenTxt.enterEmail.localize()))
            return false
        }
        if password.isEmptyString() {
            passwordTextfield.becomeFirstResponder()
            AlertManager.showAlert(on: self, type: .custom(LoginScreenTxt.enterPassword.localize()))
            return false
        }
        return true
    }
    
}


class UIShowHideTextField: UITextField {

    let rightButton  = UIButton(type: .custom)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        rightButton.setImage(UIImage(named: "password-show") , for: .normal)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 2,left: 5,bottom: 2,right: 6)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)

        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }

    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }

    func toggle() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password-show") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password-hide") , for: .normal)
        }
    }

}

