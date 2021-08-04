//
//  FilterVC.swift
//  SmileIndia
//
//  Created by Arjun  on 17/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

protocol FilterVCDelegate{
    func filterParams(selected : [String: Any])
}

class FilterVC: UIViewController {
    
    var delegate : FilterVCDelegate?

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pincodeTF: UITextField!
    @IBOutlet weak var stateTF: CustomTextfield!
    
    @IBOutlet weak var cityTF: CustomTextfield!
    @IBOutlet weak var specialityTF: CustomTextfield!
    
    @IBOutlet weak var insuranceTF: UITextField!
    
    let viewModel = FindDoctorViewModel()
    var page = 0

    var filteredParams :[String:Any]?
    
    var insuranceListforSearch = [InsuranceList]()
    var insurancePlanID = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        
        stateTF.rightViewMode = UITextField.ViewMode.always
        stateTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        cityTF.rightViewMode = UITextField.ViewMode.always
        cityTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        specialityTF.rightViewMode = UITextField.ViewMode.always
        specialityTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        insuranceTF.rightViewMode = UITextField.ViewMode.always
        insuranceTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        insuranceTF.delegate = self
        getinsurancesProvidersList()
        insuranceTF.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        
        viewModel.getSpecialities(){
            self.specialityTF.array = self.viewModel.speciality
            self.stateTF.array = self.viewModel.states
            self.cityTF.array = self.viewModel.cities
            self.setUpUI(selected: self.filteredParams ?? ["":""])
        }
        
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let showItemStoryboard = UIStoryboard(name: "insurance", bundle: nil)
        let showItemNavController = showItemStoryboard.instantiateViewController(withIdentifier: "InsuranceSearchVC") as! InsuranceSearchVC
        showItemNavController.insuranceList = self.insuranceListforSearch
        showItemNavController.delegate = self
        present(showItemNavController, animated: true, completion: nil)
     }

    
    @IBAction func didtapApply(_ sender: Any) {
            delegate?.filterParams(selected: getParameters())
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapClear(_ sender: Any) {
        self.nameTF.text = ""
        self.stateTF.text = ""
        self.cityTF.text = ""
        self.specialityTF.text = ""
        self.pincodeTF.text = ""
        self.stateTF.accessibilityLabel = "0"
        self.cityTF.accessibilityLabel = "0"
        self.specialityTF.accessibilityLabel = "0"
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapStateTextField(_ sender: Any) {
        guard let stateId = stateTF.accessibilityLabel else {
            return}
        viewModel.getCity(stateId){
            self.cityTF.array = self.viewModel.cities
                self.cityTF.accessibilityLabel = "0"
                if let object = self.viewModel.cities.filter({ $0.Value == self.cityTF.accessibilityLabel }).first {
                    self.cityTF.text = object.Text
                }
        }
    }
    
    func isValidFilter() -> Bool {
     if !pincodeTF.text!.isEmpty && (pincodeTF.text?.count ?? 0) < 6{
            AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
            return false
        }else if !pincodeTF.text!.prefix(1).allSatisfy(("1"..."9").contains) {
            AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
            return false
     }else if !nameTF.text!.prefix(1).allSatisfy(("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").contains){
            AlertManager.showAlert(type: .custom("Please Enter Valid Name."))
            return false
        }
        return true
    }
    
    func getParameters() -> [String: Any]{
        var queryItems = ["AuthKey": Constants.authKey, "PageSize": "10", "CustomerTypeId": "1", "PageNo": page] as [String : Any]
        if let name = self.nameTF.text , name.count > 0 {
            queryItems["Name"] = name
        }
        if let pincode = self.pincodeTF.text , pincode.count > 0 {
            queryItems["Pincode"] = pincode
        }
        if let city = self.cityTF.accessibilityLabel , city.count > 0 {
            queryItems["CityId"] = city
        }
        if let speciality = self.specialityTF.accessibilityLabel , speciality.count > 0 {
            queryItems["SpecialityId"] = speciality
        }
        if let state = self.stateTF.accessibilityLabel , state.count > 0 {
            queryItems["State"] = state
        }
        
        if let insurance = self.insuranceTF.text , insurance.count > 0 {
            queryItems["InsurancePlanId"] = self.insurancePlanID
         }
        
        if let insurance = self.insuranceTF.text , insurance.count > 0 {
            queryItems["InsurancePlanName"] = insurance
         }
        return queryItems
    }
    
    func setUpUI(selected:[String:Any]) -> Void {
        self.nameTF.text = "\(selected["Name"] ?? "")"
        self.pincodeTF.text = "\(selected["Pincode"] ?? "")"
        self.stateTF.accessibilityLabel = "\(selected["State"] ?? 0)"
        self.cityTF.accessibilityLabel = "\(selected["CityId"] ?? 0)"
        self.specialityTF.accessibilityLabel = "\(selected["SpecialityId"] ?? 0)"
        self.insuranceTF.text = "\(selected["InsurancePlanName"] ?? "")"
        self.insurancePlanID = Int("\(selected["InsurancePlanId"] ?? 0)") ?? 0

        guard let stateId = stateTF.accessibilityLabel else {
            return}
        viewModel.getCity(stateId){
            self.cityTF.array = self.viewModel.cities
                if let object = self.viewModel.cities.filter({ $0.Value == self.cityTF.accessibilityLabel }).first {
                    self.cityTF.text = self.cityTF.accessibilityLabel == "0" ? "": object.Text
                }
        }
        if "\(selected["State"] ?? 0)" != "0" {
            if let object = self.viewModel.states.filter({ $0.Value == stateTF.accessibilityLabel }).first {
                stateTF.text = object.Text
            }
        }else{stateTF.text = ""}
        
        if "\(selected["CityId"] ?? 0)" != "0" {
            if let object = self.viewModel.cities.filter({ $0.Value == cityTF.accessibilityLabel }).first {
                cityTF.text = object.Text
            }
        }else{cityTF.text = ""}
        
        if "\(selected["SpecialityId"] ?? 0)" != "0" {
            if let object = self.viewModel.speciality.filter({ $0.Value == specialityTF.accessibilityLabel }).first {
                specialityTF.text = object.Text
            }
        }else{specialityTF.text = ""}    }
}

extension FilterVC:InsuranceSearchVCDelegate ,UITextFieldDelegate{
func selectedInsurance(planName: String, planID: Int, providerID: Int, isAccepted: Bool) {
    self.insuranceTF.text = planName
    self.insurancePlanID = planID
}
       func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == insuranceTF{
               resignFirstResponder()
           }
       }
    func getinsurancesProvidersList(){
        let queryItems = ["":""]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
             WebService.insurancesProvidersAndPlans(queryItems: queryItems) { (result) in
                 DispatchQueue.main.async {
                     switch result {
                     case .success(let response):
                            self.insuranceListforSearch = response.objects?.filter({/$0.InsurancesPlansList?.count>0}) ?? []
                     case .failure(let error):
                         AlertManager.showAlert(type: .custom(error.message))
                     }
                   self.view.activityStopAnimating()
                 }
             }
         }
}
