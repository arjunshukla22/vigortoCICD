//
//  MemberRegistrationController.swift
//  SmileIndia
//
//  Created by Na on 19/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import ActiveLabel
import Localize

class MemberRegistrationController: UIViewController {
    
    @IBOutlet var agreeHippaBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryCodeView: UIView!
    
    @IBOutlet weak var timeZoneTextField: CustomTextfield!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: CustomTextfield!
    @IBOutlet weak var dobTextField: CustomTextfield!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var refcodeTextfield: UITextField!
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var TimeZoneLabel: UILabel!
    let viewmodel = SignupViewModel()
    var dict = [String: Any]()
    
    
    let pvStart = UIPickerView()
    var selectedStart = 0
    var timeZoneId = ""
    
    var countryCodeName = "US"

    var userstimeZone: String {
    return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ?.daylightSaving :.standard,locale: .current) ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

        hideKeyboardWhenTappedAround()
        let timezonea = TimeZone.current
        self.timeZoneTextField.text = "\(timezonea)"
        agreeHippaBtn.layer.cornerRadius = 5
        agreeHippaBtn.layer.borderWidth = 2
        agreeHippaBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        agreeBtn.layer.cornerRadius = 5
        agreeBtn.layer.borderWidth = 2
        agreeBtn.layer.borderColor = UIColor.darkGray.cgColor
        
      /*  countryCodeView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countrycodeList))
        countryCodeView.addGestureRecognizer(tapGesture) */
        
        viewmodel.getTimeZone(){
        self.createPicker()
        self.dismissPickerView()
        self.getAutomaticTimeZoneAndId()
        self.view.activityStopAnimating()
      }
        setupLbl()
    }
    
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // First Name
        FirstNameLabel.attributedText = HeadingLblTxt.DocProfileOne.firstName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Last Name
        LastNameLabel.attributedText = HeadingLblTxt.DocProfileOne.LastName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select Email
        EmailLabel.attributedText = HeadingLblTxt.DocProfileOne.Email.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select phoneNumber
        PhoneLabel.attributedText = HeadingLblTxt.DocProfileOne.phnNumber.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select TimeZone
        TimeZoneLabel.attributedText = HeadingLblTxt.DocProfileOne.timeZone.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
    }
    func createPicker() -> Void {
        pvStart.delegate = self
        timeZoneTextField.rightViewMode = UITextField.ViewMode.always
        timeZoneTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        timeZoneTextField.inputView = pvStart
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        button.tintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        timeZoneTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if timeZoneTextField.isEditing == true {
           timeZoneTextField.text = self.viewmodel.timezoneModel[selectedStart].DisplayName
            self.timeZoneId = self.viewmodel.timezoneModel[selectedStart].Id ?? ""
        }
       view.endEditing(true)
    }
    
    func getAutomaticTimeZoneAndId() -> Void {
        if let object = self.viewmodel.timezoneModel.filter({ $0.Id ==  self.userstimeZone }).first {
             timeZoneTextField.text = object.DisplayName
             self.timeZoneId = object.Id ?? ""
        }
    }
    
    @objc func countrycodeList(){
      print("Country code list")
        let countryView = CountrySelectView.shared
               countryView.barTintColor = .red
               countryView.displayLanguage = .english
               countryView.show()
               countryView.selectedCountryCallBack = { (countryDic) -> Void in
                   
                   self.countryImage.image = countryDic["countryImage"] as? UIImage
                   self.countryCodeLabel.text = "+\(countryDic["code"] as! NSNumber)"
                   self.countryCodeName = "\(countryDic["locale"] ?? "US")"
               }
    }
    
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    
    
    @IBAction func didTapAgreeHippa(_ sender: Any) {
        if agreeHippaBtn.hasImage(named: "tick.png", for: .normal) {
                   agreeHippaBtn.setImage(nil, for: .normal)
               } else {
                   agreeHippaBtn.setImage(UIImage(named: "tick.png"), for: .normal)
               }
    }
    
    @IBAction func didTapAgree(_ sender: UIButton) {
        if agreeBtn.hasImage(named: "tick.png", for: .normal) {
            agreeBtn.setImage(nil, for: .normal)
        } else {
            agreeBtn.setImage(UIImage(named: "tick.png"), for: .normal)
        }
        
    }
    
    @IBAction func didtapHippa(_ sender: Any) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "HIPAA authorization"
        termsVc.requestURLString = "https://vigorto.com/vigorto-hipaa-authorization.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapPolicy(_ sender: UIButton) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "Privacy Policy"
        termsVc.requestURLString = "https://www.vigorto.com/security-and-privacy.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    @IBAction func didTapTerms(_ sender: UIButton) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "Terms & Conditions"
        termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    @IBAction func didTapNextButton(_ sender: Any) {
        if isValid() {
            dict["AuthKey"] = Constants.authKey
            dict["FirstName"] = firstNameTextField.text
            dict["LastName"] = lastNameTextField.text
            dict["Email"] = emailTextField.text
            dict["Phone"] = phoneTextField.text
            dict["TimeZoneId"] = self.timeZoneId
            if refcodeTextfield.text!.isEmpty {
            dict["ReferralCode"] = "115517"
            }else if refcodeTextfield.text!.count > 3
            {
            dict["ReferralCode"] = refcodeTextfield.text
            }
            
            dict["CountryCode"] = self.countryCodeLabel.text
            dict["CountryNameCode"] = self.countryCodeName
           // NavigationHandler.pushTo(.memberAddress(dict))
            
            registerMember(dict)
        }
    }
}
extension MemberRegistrationController{
    func isValid() -> Bool {
        if  firstNameTextField.text?.isEmptyString() ?? false  {
            firstNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.firstName.localize()))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false  {
            lastNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.lastName.localize()))
            return false
        } else if emailTextField.text?.isEmptyString() ?? false || !(emailTextField.text?.isValidEmail() ?? false) {
            emailTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.Email.localize()))
            return false
        }
        else if phoneTextField.text?.isEmptyString() ?? false || phoneTextField.text!.count < 10 {
            phoneTextField.becomeFirstResponder()
           AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
           return false
           
       }else if refcodeTextfield.text!.count < 4 && refcodeTextfield.text!.count > 0 {
        refcodeTextfield.becomeFirstResponder()
        AlertManager.showAlert(type: .custom(ProfileUpdate.referralCode.localize()))
        return false
    }
  else if !agreeBtn.hasImage(named: "tick.png", for: .normal) {
            AlertManager.showAlert(type: .custom(ProfileUpdate.aceeptTermsConditions.localize()))
            return false
        }
        else if !agreeHippaBtn.hasImage(named: "tick.png", for: .normal) {
            AlertManager.showAlert(type: .custom(ProfileUpdate.acceptHIPAA.localize()))
            return false
        }
        return true
        
    }
}


extension MemberRegistrationController{
func registerMember(_ query: [String: Any])  {
    self.view.endEditing(true)
    self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
    WebService.Save_Member_Api(queryItems: query) { (result) in
        DispatchQueue.main.async {
            activityIndicator.hideLoader()
            switch result {
            case .success(let response):
                print(response.message as Any)
                AlertManager.showAlert(type: .custom( "Registered successfully!.Confirmation will be sent to the registered email Id."), title: AlertBtnTxt.okay.localize(), action: {
                    NavigationHandler.setRoot(.welcome)
                })
            case .failure(let error):
                AlertManager.showAlert(type: .custom(error.message))
            }
            self.view.activityStopAnimating()
        }
    }
}
}

extension MemberRegistrationController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewmodel.timezoneModel.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.viewmodel.timezoneModel[row].DisplayName ?? ""
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewmodel.timezoneModel[row].DisplayName ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           selectedStart = row
    }

}
