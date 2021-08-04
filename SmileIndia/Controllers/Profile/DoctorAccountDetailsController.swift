//
//  DoctorAccountDetailsController.swift
//  SmileIndia
//
//  Created by Na on 03/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class DoctorAccountDetailsController: BaseViewController {
    
    @IBOutlet weak var titleTextField: CustomTextfield!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: CustomTextfield!
    @IBOutlet weak var specialityTextField: CustomTextfield!
    @IBOutlet weak var registrationTextField: UITextField!
    var viewModel = ProfileViewModel()
    var dict = [String: Any]()
    var doctor: DoctorData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getTitles() {
            self.titleTextField.array = self.viewModel.titles
            self.genderTextField.array = self.viewModel.gender
            self.specialityTextField.array = self.viewModel.speciality
            self.getprofile()
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if isValid() {
            dict["AuthKey"] = Constants.authKey
            dict["TitleId"] = titleTextField.accessibilityLabel
            dict["FirstName"] = firstNameTextField.text
            dict["LastName"] = lastNameTextField.text
            dict["GenderId"] = genderTextField.accessibilityLabel
            dict["SpecialityId"] = specialityTextField.accessibilityLabel
            dict["RegNo"] = registrationTextField.text
            dict["CustomerTypeId"] = 1
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(doctor?.DoctorAddressTimmingList)
            let json = String(data: data, encoding: .utf8)!
            dict["BussinessModelArray"] = json
            NavigationHandler.pushTo(.doctorDegree(dict, doctor!))
        }
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
}
extension DoctorAccountDetailsController{
    func isValid() -> Bool {
        if  (titleTextField.accessibilityLabel == "0" || titleTextField.accessibilityLabel == nil )  {
            AlertManager.showAlert(type: .custom("Please select title."))
            return false
        } else if  firstNameTextField.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom("Please enter first name."))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom("Please enter last name."))
            return false
        } else if (genderTextField.accessibilityLabel == "0" || genderTextField.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom("Please select gender."))
            return false
        }    else if specialityTextField.accessibilityLabel == "0" || specialityTextField.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select speciality."))
            return false
        } else if  registrationTextField.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter registration number."))
            return false
        }
        return true
    }
    
    func getprofile(){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getDoctorProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.doctor = user
                        self.setUI()
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                    self.showError(message: error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI() {
        titleTextField.accessibilityLabel = "\(doctor?.TitleId ?? 0)"
        if let object = self.viewModel.titles.filter({ $0.Value == titleTextField.accessibilityLabel }).first {
            titleTextField.text = object.Text
        }
        firstNameTextField.text = doctor?.FirstName
        lastNameTextField.text = doctor?.LastName
        genderTextField.accessibilityLabel = "\(doctor?.GenderId ?? 0)"
        if let object = self.viewModel.gender.filter({ $0.Value == genderTextField.accessibilityLabel }).first {
            genderTextField.text = object.Text
        }
        specialityTextField.accessibilityLabel = "\(doctor?.SpecialityId ?? 0)"
        if let object = self.viewModel.speciality.filter({ $0.Value == specialityTextField.accessibilityLabel }).first {
            specialityTextField.text = object.Text
        }
        registrationTextField.text = doctor?.RegNo
    }
}
