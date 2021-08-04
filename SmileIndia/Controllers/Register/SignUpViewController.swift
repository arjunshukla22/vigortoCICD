//
//  SignUpViewController.swift
//  SmileIndia
//
//  Created by Na on 10/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var titleStack: UIStackView!
    @IBOutlet weak var fNameStack: UIStackView!
    @IBOutlet weak var lnameStack: UIStackView!
    @IBOutlet weak var dStack: UIStackView!
    @IBOutlet weak var odStack: UIStackView!
    @IBOutlet weak var genderStack: UIStackView!
    
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var hospitalButton: UIButton!
    @IBOutlet weak var titleTextField: CustomTextfield!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var genderTextField: CustomTextfield!
    @IBOutlet weak var specialityTextField: CustomTextfield!
    @IBOutlet weak var registrationNumberTextField: UITextField!
   
    @IBOutlet weak var degreeTextField: CustomTextfield!
    @IBOutlet weak var otherDegreeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var osTextfiled: UITextField!
    
    
    var dict = [String: Any]()
    var customerType = "1"
    let viewmodel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

        titleTextField.rightViewMode = UITextField.ViewMode.always
        titleTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        genderTextField.rightViewMode = UITextField.ViewMode.always
        genderTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        specialityTextField.rightViewMode = UITextField.ViewMode.always
        specialityTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        degreeTextField.rightViewMode = UITextField.ViewMode.always
        degreeTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        viewmodel.hitApis{
            self.titleTextField.array = self.viewmodel.titles
            self.genderTextField.array = self.viewmodel.gender
            self.specialityTextField.array = self.viewmodel.speciality
            self.degreeTextField.array = self.viewmodel.degree
            self.view.activityStopAnimating()
        }
        activityIndicator.hideLoader()
    }
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
    //   self.isExists()
        
       if isValid() {
            if   customerType == "1" {
                if titleTextField.text == "None"{
                    dict["TitleId"] = "0"
                }
                else{
                    dict["TitleId"] = titleTextField.accessibilityLabel
                }
                
                dict["FirstName"] = firstNameTextField.text
                dict["LastName"] = lastNameTextField.text
                dict["GenderId"] = genderTextField.accessibilityLabel
                dict["DegreeId"] = degreeTextField.accessibilityLabel
                dict["OtherDegreeName"] = otherDegreeTextField.text
            }
        dict["AuthKey"] = Constants.authKey
        dict["SpecialityId"] = specialityTextField.accessibilityLabel
        dict["Otherspeciality"] = osTextfiled.text
        dict["RegNo"] = registrationNumberTextField.text
        dict["Email"] = emailTextField.text
        dict["HospitalName"] = hospitalTextField.text
        dict["CustomerTypeId"] = customerType
        
        self.isExists()
        }
    }
    
    @IBAction func didTapRadioButtons(_ sender: UIButton) {
     //   constraintViewHeight.constant = sender.tag == 1 ? 780 : 400
             titleStack.isHidden = sender.tag == 2
             fNameStack.isHidden = sender.tag == 2
             lnameStack.isHidden = sender.tag == 2
             genderStack.isHidden = sender.tag == 2
             dStack.isHidden = sender.tag == 2
             odStack.isHidden = sender.tag == 2
        /*   degreeTextField.isHidden = sender.tag == 2
         otherDegreeTextField.isHidden = sender.tag == 2
        titleTextField.isHidden = sender.tag == 2
         firstNameTextField.isHidden = sender.tag == 2
         lastNameTextField.isHidden = sender.tag == 2
         genderTextField.isHidden = sender.tag == 2
        doctorStackView.isHidden = sender.tag == 2
        degreeStackView.isHidden = sender.tag == 2
        degreeTextField.isHidden = sender.tag == 2
        otherDegreeTextField.isHidden = sender.tag == 2 */
        
        hospitalButton.setImage(UIImage.init(named: sender.tag == 1 ? "radio" : "radioSelected"), for: .normal)
        doctorButton.setImage(UIImage.init(named: sender.tag == 1 ?  "radioSelected" : "radio"), for: .normal)
        customerType = sender.tag == 1 ? "1" : "4"
     
    }
    
    
}
extension SignUpViewController{
    func isValid() -> Bool {
        if firstNameTextField.text?.isEmptyString() ?? false && customerType == "1" {
            firstNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("First Name Is Required."))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false && customerType == "1" {
            lastNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Last Name Is Required."))
            return false
        } else if (genderTextField.accessibilityLabel == "0" || genderTextField.accessibilityLabel == nil) && customerType == "1"  {
            AlertManager.showAlert(type: .custom("Gender Is Required."))
            return false
        }   else if  hospitalTextField.text?.isEmptyString() ?? false{
            hospitalTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Clinic/Practice Name Is Required."))
            return false
        }  else if specialityTextField.accessibilityLabel == "0" || specialityTextField.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Speciality Is Required."))
            return false
        } else if specialityTextField.text == "Others" && osTextfiled.text!.isEmpty {
            AlertManager.showAlert(type: .custom("Other Speciality Is Required."))
            return false
        } else if  registrationNumberTextField.text?.isEmptyString() ?? false{
            registrationNumberTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Registration Is Required."))
            return false
        } else if  registrationNumberTextField.text!.count < 4{
            registrationNumberTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Please Enter Valid Registration Number."))
            return false
        }else if (degreeTextField.accessibilityLabel == "0"  || degreeTextField.accessibilityLabel == nil) && customerType == "1" {
            AlertManager.showAlert(type: .custom("Degree Is Required."))
            return false
        } else if degreeTextField.text == "Others" && otherDegreeTextField.text!.isEmpty {
           AlertManager.showAlert(type: .custom("Other Degree Is Required."))
           return false
        }else if emailTextField.text?.isEmptyString() ?? false || !(emailTextField.text?.isValidEmail() ?? false) {
            emailTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Email Is Required."))
            return false
        }
        return true
    
    }
    
    func isExists() -> Void {

        let queryItems = ["Email":emailTextField.text!] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.isExists(queryItems: queryItems) { (result) in
            
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):print(response)
                    NavigationHandler.pushTo(.personalDetail(self.dict, self.customerType))
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }

}


