//
//  memberAddressVC.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 28/10/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class memberAddressVC: UIViewController {
    
    @IBOutlet weak var address1TF: UITextField!
    //  @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var countryTF: CustomTextfield!
    @IBOutlet weak var stateTF: CustomTextfield!
    @IBOutlet weak var cityTF: CustomTextfield!
    
    
    @IBOutlet weak var address1Lbl: UILabel!
    @IBOutlet weak var ZippostalLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    
    
    var object: Appointment?
    var dict = [String: Any]()
    var member: Member?
    var viewModel = ProfileViewModel()
    var doctor: Doctor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        stateTF.rightViewMode = UITextField.ViewMode.always
        stateTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        cityTF.rightViewMode = UITextField.ViewMode.always
        cityTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        countryTF.rightViewMode = UITextField.ViewMode.always
        countryTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
       
        viewModel.getCountry(){
            self.countryTF.array = self.viewModel.country
            self.getprofile()
        }
       // getprofile()
        activityIndicator.hideLoader()
        
        
        setUpLbl()
    }
    func setUpLbl() {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // Address 1
        address1Lbl.attributedText = HeadingLblTxt.DocProfileOne.address1.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  Zip / Postal Code
        ZippostalLbl.attributedText = HeadingLblTxt.DocProfileOne.zipPostal.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  Country
        countryLbl.attributedText = HeadingLblTxt.DocProfileOne.country.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  State
        stateLbl.attributedText = HeadingLblTxt.DocProfileOne.state.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  City
        cityLbl.attributedText = HeadingLblTxt.DocProfileOne.city.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
    }
    func getprofile(){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getMemberProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let member = response.object {
                        self.member = member
                        self.setUI(member)
                    }
                case .failure(let error):
                    print(error.message)
                // self.showError(message: error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI(_ member: Member) {
        address1TF.text = member.Address1
        
        countryTF.text = member.CountryName
        countryTF.accessibilityLabel = "\(member.CountryId ?? 0)"
        
        /*
         if let object = self.viewModel.country.filter({ $0.Value ==  countryTF.accessibilityLabel }).first {
         countryTF.text = object.Text
         }
         didTapCountryTextField(countryTF)
         stateTF.text = member.StateName
         stateTF.accessibilityLabel = "\(member.StateProvinceId ?? 0)"
         didTapStateTextField(stateTF)
         cityTF.text = member.City
         cityTF.accessibilityLabel = "\(member.CityId ?? 0)"
         */
        
        zipCodeTF.text = "\(member.ZipCode ?? 0)"
        if let object = self.viewModel.country.filter({ $0.Value ==  countryTF.accessibilityLabel }).first {
            countryTF.text = object.Text
        }else{
            self.countryTF.text = self.viewModel.country.first?.Text
        }
        didTapCountryTextField(countryTF)
        stateTF.text = member.StateName
        stateTF.accessibilityLabel = "\(member.StateProvinceId ?? 0)"
        didTapStateTextField(stateTF)
        cityTF.text = member.City
        cityTF.accessibilityLabel = "\(member.CityId ?? 0)"
    }
    
    
    @IBAction func didTapCountryTextField(_ sender: Any) {
        viewModel.getCountry(){
            self.countryTF.array = self.viewModel.country
            guard let countryid = self.countryTF.accessibilityLabel else {
                return
            }
            
            // Show Loader
            self.ShowLoader()
            self.viewModel.getState(countryid){
                // Show Loader
                self.HideLoader()
                self.stateTF.array = self.viewModel.states
                guard let stateid = self.member?.StateProvinceId else {
                    return
                }
                self.stateTF.accessibilityLabel = "\(stateid)"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTF.accessibilityLabel }).first {
                    self.stateTF.text = object.Text
                   
                }else{
                    self.stateTF.accessibilityLabel = /self.viewModel.states.first?.Value
                    self.stateTF.text = self.viewModel.states.first?.Text
                }
                
                self.didTapStateTextField(self.stateTF)
            }
        }
        
    }
    
    @IBAction func didTapStateTextField(_ sender: Any)  {
        guard let stateId = stateTF.accessibilityLabel else {
            return}
        
        
        // Show Loader
        self.ShowLoader()
        
        viewModel.getCity(stateId){
            
            // Show Loader
            self.HideLoader()
            
            self.cityTF.array = self.viewModel.cities
            
            guard let cityId = self.member?.CityId  else {
                return
            }
            self.cityTF.accessibilityLabel = "\(cityId)"
            if let object = self.viewModel.cities.filter({ $0.Value == self.cityTF.accessibilityLabel }).first {
                self.cityTF.text = object.Text
            }else{
                self.cityTF.text = self.viewModel.cities.first?.Text
            }
        }
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        print("sdsadsad")
        self.dismiss(animated: true, completion: nil)
        
        if self.isValid() {
           
            AlertManager.showAlert(type: .custom(ProfileUpdate.areYouSureUpdateProfile.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                
                self.dict["ZipCode"] = self.zipCodeTF.text ?? "0"
                self.dict["CountryId"] = self.countryTF.accessibilityLabel ?? "0"
                self.dict["StateId"] = self.stateTF.accessibilityLabel ?? "0"
                self.dict["CityId"] = self.cityTF.accessibilityLabel ?? "0"
                self.dict["Address1"] = self.address1TF.text
                // self.dict["Address2"] = self.address2TF.text
                self.dict["MemberId"] = Authentication.customerId ?? "0"
                self.dict["DeviceType"] = "m"
                
                self.uploadLocalAddress(self.dict)
                // self.updateMember(self.dict)
            }
        }
        
    }
    func isValid() -> Bool {
        
        if zipCodeTF.text! == ""
        {
            AlertManager.showAlert(type: .custom(ProfileUpdate.pinCode.localize()))
            return false
        }
        
        else if address1TF .text! == ""
        {
            AlertManager.showAlert(type: .custom(ProfileUpdate.address.localize()))
            return false
        }
        /* else if address2TF .text! == ""
         {
         AlertManager.showAlert(type: .custom("Address Is Required."))
         return false
         }*/
        else if (countryTF.accessibilityLabel == "0" || countryTF.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.country.localize()))
            return false
        }
        else if (stateTF.accessibilityLabel == "0" || stateTF.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.State.localize()))
            return false
        } else if (cityTF.accessibilityLabel == "0" || cityTF.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.city.localize()))
            return false
        }
        
        return true
    }
    
    
    
}

extension memberAddressVC {
    func uploadLocalAddress(_ query: [String: Any])  {
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.UploadLocalAddress(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("response succ")
                    AlertManager.showAlert(type: .custom( response.message ?? ""), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.pop()
                        
                    })
                case .failure(let error):
                    print("response failed")
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
}

