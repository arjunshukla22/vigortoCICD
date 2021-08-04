//
//  MemberChangePasswordController.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class MemberChangePasswordController: BaseViewController {

    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        hideKeyboardWhenTappedAround()


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
            WebService.changePasswordMember(queryItems: queryItems) { (result) in
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
extension MemberChangePasswordController {
    func isValid() -> Bool {
        let substring = Authentication.token?.fromBase64()?.components(separatedBy: ":")
        guard let password = substring?[1] else {
            return false
        }
        if  oldPasswordTextfield.text?.isEmptyString() ?? false || oldPasswordTextfield.text?.count ?? 0 < 3 {
            AlertManager.showAlert(type: .custom("Please enter old password."))
            return false
        } else if newPasswordTextfield.text?.isEmptyString() ?? false || newPasswordTextfield.text?.count ?? 0 < 3 {
            AlertManager.showAlert(type: .custom("Please enter new password."))
            return false
        } else if  confirmPasswordTextfield.text?.isEmptyString() ?? false || confirmPasswordTextfield.text?.count ?? 0 < 3 {
            AlertManager.showAlert(type: .custom("Please enter confirm password."))
            return false
        } else if  oldPasswordTextfield.text != password {
            AlertManager.showAlert(type: .custom("Old password does not match."))
            return false
        }
        else if confirmPasswordTextfield.text ?? "" !=  newPasswordTextfield.text ?? "" {
            AlertManager.showAlert(type: .custom("New and confirm password should match."))
            return false
        }
        return true
    }
    
}
