//
//  ForgotPasswordController.swift
//  SmileIndia
//
//  Created by Na on 10/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        emailTextfield.rightViewMode = UITextField.ViewMode.always
        emailTextfield.rightView = UIImageView(image: UIImage(named: "mail"))
        


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NavigationHandler.hideNavigationBar()
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapRecoverAccount(_ sender: Any) {
        self.view.endEditing(true)
        if isValid() {
            let queryItems = ["AuthKey": Constants.authKey ,
                              "UserEmail": emailTextfield.text ?? ""] as [String : Any]
            self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
            WebService.forgotPassword(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        AlertManager.showAlert(type: .custom(response.message ?? "")) {
                            Authentication.clearData()
                            NavigationHandler.logOut()
                        }
                    case .failure(let error):
                        self.showError(message: error.message) }
                    self.view.activityStopAnimating()
                }
            }
        }
    }
    
    
    @IBAction func didTapCreateAccount(_ sender: Any) {
   //     NavigationHandler.pushTo(.signup)
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popOverVC, animated: true)
    }
    
}
extension ForgotPasswordController{
    func isValid() -> Bool {
        guard let email = emailTextfield.text else {return false}
        if email.isEmptyString() || !email.isValidEmail(){
            emailTextfield.becomeFirstResponder()
            AlertManager.showAlert(on: self, type: .custom(LoginScreenTxt.enterEmail.localize()))
            return false
        }
        return true
    }
}
