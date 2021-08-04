
//
//  DoctorAddressController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class DoctorAddressController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var consultationfeeTextfield: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var cityTextField: CustomTextfield!
    @IBOutlet weak var stateTextField: CustomTextfield!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var viewModel = ProfileViewModel()
    var doctor: DoctorData?
    var dict = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewModel.getState(countryId) {
        //    self.stateTextField.array = self.viewModel.states
        //    self.setUI()
      //  }
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapStateTextField(_ sender: Any) {
        guard let stateId = stateTextField.accessibilityLabel else {
            return}
        viewModel.getCity(stateId){
            self.cityTextField.array = self.viewModel.cities
            guard let cityId = self.doctor?.CityId  else {
                return
            }
            self.cityTextField.accessibilityLabel = "\(cityId)"
            if let object = self.viewModel.cities.filter({ $0.Value == self.cityTextField.accessibilityLabel }).first {
                self.cityTextField.text = object.Text
            }
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if isValid() {
            dict["ZipCode"] = zipTextField.text
            dict["StateId"] = stateTextField.accessibilityLabel
            dict["CityId"] = cityTextField.accessibilityLabel
            dict["Address1"] = addressTextField.text
            dict["Address2"] = address2TextField.text
            dict["ConsultationFee"] = consultationfeeTextfield.text
            NavigationHandler.pushTo(.doctorImage(dict, doctor!))
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
}

extension DoctorAddressController {
    func isValid() -> Bool {
        if  zipTextField.text?.isEmptyString() ?? false || zipTextField.text?.count ?? 0 < 6 {
            AlertManager.showAlert(type: .custom("Please enter zipcode."))
            return false
        } else if  stateTextField.accessibilityLabel == "0" || stateTextField.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select state."))
            return false
        }else if cityTextField.accessibilityLabel == "0" || cityTextField.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select city."))
            return false
        }
        else if addressTextField.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter address line 1."))
            return false
        }
        else if consultationfeeTextfield.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter consultation fee."))
            return false
        }
        return true
        
    }
    func setUI() {
        consultationfeeTextfield.text = "\(doctor?.ConsultationFee ?? 0)"
        zipTextField.text = doctor?.ZipCode
        stateTextField.accessibilityLabel = "\(doctor?.StateId ?? 0)"
        if let object = self.viewModel.states.filter({ $0.Value == stateTextField.accessibilityLabel }).first {
            stateTextField.text = object.Text
            self.didTapStateTextField(UIButton())
        }
        addressTextField.text = doctor?.Address1
        address2TextField.text = doctor?.Address2
    }
}

