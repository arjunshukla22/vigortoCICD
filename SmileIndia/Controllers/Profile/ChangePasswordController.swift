//
//  ChangePasswordController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import Localize

class ChangePasswordController: BaseViewController {
    
    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    // Heading Label
    @IBOutlet weak var oldPwdLbl: UILabel!
    @IBOutlet weak var newPwdLbl: UILabel!
    @IBOutlet weak var ConfirmPwdLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        setUpLbl()
    }
    
    func setUpLbl() {
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // Phone
        oldPwdLbl.attributedText = HeadingLblTxt.ChangePassword.oldPwd.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Address 1
        newPwdLbl.attributedText = HeadingLblTxt.ChangePassword.newPwd.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Address 2
        ConfirmPwdLbl.attributedText = HeadingLblTxt.ChangePassword.confirmPwd.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        if isValid() {
            let queryItems = ["LoginKey": Authentication.token ?? "",
                              "NewPassword": newPasswordTextfield.text ?? ""] as [String : Any]
            
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            WebService.changePassword(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let substring = Authentication.token?.fromBase64()?.components(separatedBy: ":")
                        Authentication.token = "\(substring?[0] ?? ""):\(self.newPasswordTextfield.text ?? "")".toBase64()
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
    
    
}
extension ChangePasswordController {
    func isValid() -> Bool {
        
        //        let substring = Authentication.token?.fromBase64()?.components(separatedBy: ":")
        //        guard let password = substring?[1] else {
        //            return false
        //        }
        if  oldPasswordTextfield.text?.isEmptyString() ?? false  {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.pleaseEnterOldPwd.localize()))
            return false
        }
        
        else if  oldPasswordTextfield.text?.count ?? 0 < 5 {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.oldPwdContainsMin.localize()))
            return false
        }
        
        // New Password
        else if newPasswordTextfield.text?.isEmptyString() ?? false  {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.pleaseEnterNewPwd.localize()))
            return false
        }
        
        else if newPasswordTextfield.text?.count ?? 0 < 5 {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.newPwdContainsMin.localize()))
            return false
        }
        
        // Confirm Password
        else if  confirmPasswordTextfield.text?.isEmptyString() ?? false || confirmPasswordTextfield.text?.count ?? 0 < 5 {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.pleaseEnterConfirmPwd.localize()))
            return false
        }
        else if confirmPasswordTextfield.text ?? "" !=  newPasswordTextfield.text ?? "" {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.confirmPwdNotMatchedNewPwd.localize()))
            return false
        }
        else if oldPasswordTextfield.text ?? "" !=  /Authentication.customerPassword {
            AlertManager.showAlert(type: .custom(ChangePasswordScreenTxt.oldPwdNotMatched.localize()))
            return false
        }
        return true
    }
    
}

//else if  oldPasswordTextfield.text != password {
//           AlertManager.showAlert(type: .custom("You entered the password that is the same as one of the last passwords you used. Please create a new password."))
//           return false
//       }
