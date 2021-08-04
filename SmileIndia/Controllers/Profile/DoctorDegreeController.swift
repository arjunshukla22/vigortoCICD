
//
//  DoctorDegreeController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class DoctorDegreeController: UIViewController {

    @IBOutlet weak var degreeTextfield: CustomTextfield!
    @IBOutlet weak var otherDegreeTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var alternatePhoneTextfield: UITextField!
    @IBOutlet weak var hospitalTextfield: UITextField!
    var viewModel = ProfileViewModel()
    var doctor: DoctorData?
    var dict = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDegree() {
            self.degreeTextfield.array = self.viewModel.degree
            self.setUI()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if isValid() {
            dict["DegreeId"] = degreeTextfield.accessibilityLabel
            dict["OtherDegreeName"] = otherDegreeTextfield.text
            dict["Email"] = emailTextfield.text
            dict["Phone"] = phoneTextfield.text
            dict["AlternatePhoneNo"] = alternatePhoneTextfield.text
            dict["HospitalName"] = hospitalTextfield.text
            NavigationHandler.pushTo(.doctorAddress(dict, doctor!))
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }

}
extension DoctorDegreeController {
    func isValid() -> Bool {
        if degreeTextfield.accessibilityLabel == "0"  || degreeTextfield.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select degree."))
            return false
        }else if emailTextfield.text?.isEmptyString() ?? false || !(emailTextfield.text?.isValidEmail() ?? false) {
            AlertManager.showAlert(type: .custom("Please enter email id."))
            return false
        } else  if phoneTextfield.text?.isEmptyString() ?? false || phoneTextfield.text?.count ?? 0 < 10 {
            AlertManager.showAlert(type: .custom("Please enter phone number."))
            return false
        } else if  hospitalTextfield.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom("Please enter hospital name."))
            return false
        }
        return true
    }
    func setUI() {
        degreeTextfield.accessibilityLabel = "\(doctor?.DegreeId ?? 0)"
        if let object = self.viewModel.degree.filter({ $0.Value == degreeTextfield.accessibilityLabel }).first {
            degreeTextfield.text = object.Text
        }
        otherDegreeTextfield.text = doctor?.OtherDegreeName
        emailTextfield.text = doctor?.Email
        phoneTextfield.text = doctor?.Phone
        alternatePhoneTextfield.text = doctor?.AlternatePhoneNo
        hospitalTextfield.text = doctor?.HospitalName
    }
}
