//
//  MemberProfileController.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Localize

class MemberProfileController: BaseViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: CustomTextfield!
    @IBOutlet weak var dobTextField: CustomTextfield!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var address2NameTextField: UITextField!
    
    @IBOutlet weak var timeZoneTextField: UITextField!
    @IBOutlet weak var countryTextField: CustomTextfield!
    @IBOutlet weak var stateTextField: CustomTextfield!
    @IBOutlet weak var cityTextField: CustomTextfield!
    @IBOutlet weak var pincodeTextField: UITextField!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var phoneNameTextField: UITextField!
    
    
    @IBOutlet weak var FirstNameLabel: UILabel!
    @IBOutlet weak var LastNameLabel: UILabel!
    @IBOutlet weak var TimeZoneLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    
    var calendarData: CalendarData?
    //  let datePicker = DatePickerDialog()
    var viewModel = ProfileViewModel()
    var dict = [String: Any]()
    
    var member: Member?
    
    var touchState = 0
    let pvStart = UIPickerView()
    var selectedStart = 0
    var timeZoneId = ""
    
    
    var userstimeZone: String {
        return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ?.daylightSaving :.standard,locale: .current) ?? ""
    }
    
    var countryCodeName = "US"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        emailTextField.isUserInteractionEnabled = false
        
        genderTextField.rightViewMode = UITextField.ViewMode.always
        genderTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        dobTextField.rightViewMode = UITextField.ViewMode.always
        dobTextField.rightView = UIImageView(image: UIImage(named: "cal"))
        dobTextField.delegate = self
        stateTextField.rightViewMode = UITextField.ViewMode.always
        stateTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        cityTextField.rightViewMode = UITextField.ViewMode.always
        cityTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        countryTextField.rightViewMode = UITextField.ViewMode.always
        countryTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        // timeZoneTextField.rightViewMode = UITextField.ViewMode.always
        //     timeZoneTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        viewModel.getTimeZone(){
            self.createPicker()
            self.dismissPickerView()
            self.getAutomaticTimeZoneAndId()
        }
        viewModel.getCountry() {

               }
        
        viewModel.getGender() {
            self.genderTextField.array = self.viewModel.gender
            self.getprofile()
        }
        /*  countryCodeView.isUserInteractionEnabled = true
         let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countrycodeList))
         countryCodeView.addGestureRecognizer(tapGesture) */
        setupLbl()
    }
    
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        

        // First Name
        FirstNameLabel.attributedText = HeadingLblTxt.DocProfileOne.firstName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
       
        TimeZoneLabel.attributedText = HeadingLblTxt.DocProfileOne.timeZone.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Last Name
        LastNameLabel.attributedText = HeadingLblTxt.DocProfileOne.LastName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select gender
        EmailLabel.attributedText = HeadingLblTxt.DocProfileOne.Email.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Clinic Practice
        PhoneLabel.attributedText = HeadingLblTxt.DocProfileOne.phnNumber.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
       
      

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
            timeZoneTextField.text = self.viewModel.timezoneModel[selectedStart].DisplayName
            self.timeZoneId = self.viewModel.timezoneModel[selectedStart].Id ?? ""
        }
        view.endEditing(true)
    }
    
    func getAutomaticTimeZoneAndId() -> Void {
        if let object = self.viewModel.timezoneModel.filter({ $0.Id ==  member?.TimeZoneId }).first {
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
            
            self.flagImageView.image = countryDic["countryImage"] as? UIImage
            self.countryCodeLabel.text = "+\(countryDic["code"] as! NSNumber)"
            self.countryCodeName = "\(countryDic["locale"] ?? "US")"
            
        }
    }
    
    func SetUpCountryTextField(_ sender: Any)
    {
        viewModel.getCountry(){
        self.countryTextField.array = self.viewModel.country
        guard let countryid = self.countryTextField.accessibilityLabel else {
            return
            
        }
        self.viewModel.getState(countryid){
            self.stateTextField.array = self.viewModel.states
            
            if self.touchState == 1{
                self.stateTextField.accessibilityLabel = "0"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTextField.accessibilityLabel }).first {
                    self.stateTextField.text = object.Text
                }
            }
            else{
                guard let stateid = self.member?.StateProvinceId else {
                    return
                }
                self.stateTextField.accessibilityLabel = "\(stateid)"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTextField.accessibilityLabel }).first {
                    self.stateTextField.text = object.Text
        
                }
                else{
                    self.stateTextField.accessibilityLabel = "\(/self.viewModel.states.first?.Value)"
                    self.stateTextField.text = self.viewModel.states.first?.Text
                }
                
//                self.stateTextField.accessibilityLabel = "0"
               // self.didTapStateTextField(self.stateTextField)
                self.SetUpStateTextField(self.stateTextField)

            }}
        self.touchState = 0
    }
    
    }
    
    func SetUpStateTextField(_ sender: Any)  {
        ez.runThisInMainThread {
            guard let stateId = self.stateTextField.accessibilityLabel else {
                return}
            self.viewModel.getCity(stateId){
                self.cityTextField.array = self.viewModel.cities
                
                if self.touchState == 1{
                    self.cityTextField.accessibilityLabel = "0"
                    if let object = self.viewModel.cities.filter({ $0.Value == self.cityTextField.accessibilityLabel }).first {
                        self.cityTextField.text = object.Text
                    }
                }else{
                    guard let cityId = self.member?.CityId  else {
                        return
                    }
                    self.cityTextField.accessibilityLabel = "\(cityId)"
                    if let object = self.viewModel.cities.filter({ $0.Value == self.cityTextField.accessibilityLabel }).first {
                        self.cityTextField.text = object.Text
                    }
                    else
                    {
                        self.cityTextField.text = self.viewModel.cities.first?.Text
                    }
                }
                self.touchState = 0
            }
        }
    }
    
    @IBAction func didTapCountryTextField(_ sender: Any)
    {
        viewModel.getCountry(){
        self.countryTextField.array = self.viewModel.country
        guard let countryid = self.countryTextField.accessibilityLabel else {
            return
            
        }
        self.viewModel.getState(countryid){
            self.stateTextField.array = self.viewModel.states
            
            if self.touchState == 1{
                self.stateTextField.accessibilityLabel = "0"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTextField.accessibilityLabel }).first {
                    self.stateTextField.text = object.Text
                }
            }
            else{
//                guard let stateid = self.member?.StateProvinceId else {
//                    return
//                }
//                self.stateTextField.accessibilityLabel = "\(stateid)"
                self.stateTextField.accessibilityLabel = "0"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTextField.accessibilityLabel }).first {
                    self.stateTextField.text = object.Text
                   
                }
                else{
                    self.stateTextField.accessibilityLabel = "\(/self.viewModel.states.first?.Value)"
                    self.stateTextField.text = self.viewModel.states.first?.Text
                }
                
//                self.stateTextField.accessibilityLabel = "0"
                self.didTapStateTextField(self.stateTextField)
                
            }}
        self.touchState = 0
    }
    
    }
    
    @IBAction func didTapStateTextField(_ sender: Any)  {
        
        ez.runThisInMainThread {
            guard let stateId = self.stateTextField.accessibilityLabel else {
                return}
            self.viewModel.getCity(stateId){
                self.cityTextField.array = self.viewModel.cities
                
                if self.touchState == 1{
                    self.cityTextField.accessibilityLabel = "0"
                    if let object = self.viewModel.cities.filter({ $0.Value == self.cityTextField.accessibilityLabel }).first {
                        self.cityTextField.text = object.Text
                    }
                }else{
//                    guard let cityId = self.member?.CityId  else {
//                        return
//                    }
//                    self.cityTextField.accessibilityLabel = "\(cityId)"
                    self.cityTextField.accessibilityLabel = "0"
                    if let object = self.viewModel.cities.filter({ $0.Value == self.cityTextField.accessibilityLabel }).first {
                        self.cityTextField.text = object.Text
                    }
                    else
                    {
                        self.cityTextField.text = self.viewModel.cities.first?.Text
                    }
                }
                self.touchState = 0
            }
        }
        
        
       
    }
    
    
    @IBAction func didTapNextButton(_ sender: Any) {
        
        if self.isValid() {
           
         //   AlertManager.showAlert(type: .custom(ProfileUpdate.dobValidation.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                self.dict["LoginKey"] = Authentication.token ?? ""
                self.dict["FirstName"] = self.firstNameTextField.text
                self.dict["LastName"] = self.lastNameTextField.text
                self.dict["GenderId"] = self.genderTextField.accessibilityLabel
                self.dict["DateOfBirth"] = self.dobTextField.text?.replacingOccurrences(of: "-", with: "/")
                self.dict["Email"] = self.emailTextField.text
                self.dict["Phone"] = self.phoneNameTextField.text
                self.dict["ZipCode"] = self.pincodeTextField.text
                self.dict["TimeZoneId"] = self.timeZoneId
                self.dict["CountryId"] = self.countryTextField.accessibilityLabel
                self.dict["StateProvinceId"] = self.stateTextField.accessibilityLabel
                self.dict["CityId"] = self.cityTextField.accessibilityLabel
                self.dict["Address1"] = self.addressNameTextField.text
                self.dict["Address2"] = self.address2NameTextField.text
                self.dict["CountryCode"] = self.countryCodeLabel.text
                self.dict["CountryNameCode"] = self.countryCodeName
                self.updateMember(self.dict)
         //   }
        }
        
    }
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -18
        var maxdatecomponent = DateComponents()
        maxdatecomponent.year = -120
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let minDate = Calendar.current.date(byAdding: maxdatecomponent, to: currentDate)
        let selectedDate = Date()
        
        RPicker.selectDate(title: "Select Date", selectedDate: selectedDate, minDate: minDate, maxDate: maxDate) { [weak self] (selectedDate) in
            // TODO: Your implementation for date
            //            self?.outputLabel.text = selectedDate.dateString("MMM-dd-YYYY")
            //
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            self?.dobTextField.text = formatter.string(from: selectedDate)
            
        }
    }
    
    //yyyy/MM/dd
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    
    
}
extension MemberProfileController {
    func updateMember(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.updateMember(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom( response.message ?? ""), title: AlertBtnTxt.okay.localize(), action: {
                        Authentication.customerName =  self.firstNameTextField.text! + " " + self.lastNameTextField.text!
                        NavigationHandler.pop()
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func isValid() -> Bool {
        
        if  firstNameTextField.text?.isEmptyString() ?? false {
            firstNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.firstName.localize()))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false {
            lastNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.lastName.localize()))
            return false
        }else if emailTextField.text?.isEmptyString() ?? false || !(emailTextField.text?.isValidEmail() ?? false) {
            emailTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.Email.localize()))
            return false
        } else if phoneNameTextField.text?.isEmptyString() ?? false || phoneNameTextField.text!.count  < 10 {
            phoneNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
        }
        
        else if countryTextField.accessibilityLabel != "0" && stateTextField.accessibilityLabel != "0" && cityTextField.accessibilityLabel == "0"{
            AlertManager.showAlert(type: .custom(ProfileUpdate.city.localize()))
            return false
        }
        // Time Zone
        else if  timeZoneTextField.text == "Select TimeZone" || timeZoneTextField.text == ""{
            AlertManager.showAlert(type: .custom(ProfileUpdate.timeZone.localize()))
            return false
        }/*else if !pincodeTextField.text!.isEmpty && !pincodeTextField.text!.prefix(1).allSatisfy(("1"..."9").contains) {
         AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
         return false
         }
         else if !pincodeTextField.text!.isEmpty && pincodeTextField.text!.count < 6
         {
         AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
         return false
         }else if cityTextField.text! == "None"
         {
         AlertManager.showAlert(type: .custom("City Is Required."))
         return false
         }*/
        
        return true
    }
    
    func isValidOld() -> Bool {
        if  firstNameTextField.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom(ProfileUpdate.firstName.localize()))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom(ProfileUpdate.lastName.localize()))
            return false
        } else if (genderTextField.accessibilityLabel == "0" || genderTextField.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.gender.localize()))
            return false
        }  else if (dobTextField.accessibilityLabel == "0" || dobTextField.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.dobValidation.localize()))
            
            return false
        }else if emailTextField.text?.isEmptyString() ?? false || !(emailTextField.text?.isValidEmail() ?? false) {
            AlertManager.showAlert(type: .custom(ProfileUpdate.Email.localize()))
            return false
        } else if phoneNameTextField.text?.isEmptyString() ?? false || phoneNameTextField.text!.count < 10 {
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
        } else if  addressNameTextField.text?.isEmptyString() ?? false {
            AlertManager.showAlert(type: .custom(ProfileUpdate.address.localize()))
            return false
        }/* else if (stateTextField.accessibilityLabel == "0" || stateTextField.accessibilityLabel == nil)  {
         AlertManager.showAlert(type: .custom("State Is Required."))
         return false
         } else if (cityTextField.accessibilityLabel == "0" || cityTextField.accessibilityLabel == nil)  {
         AlertManager.showAlert(type: .custom("City Is Required."))
         return false
         }*/
        /*else if pincodeTextField.text!.prefix(1).allSatisfy(("1"..."9").contains) {
         AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
         return false
         }*/
        return true
    }
    
    func getprofile(){
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
                    self.showError(message: error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI(_ member: Member) {
        firstNameTextField.text = member.FirstName
        
        if let object = self.viewModel.timezoneModel.filter({ $0.Id ==  member.TimeZoneId }).first {
            self.timeZoneId = object.Id ?? ""
            timeZoneTextField.text = object.DisplayName
        }
        lastNameTextField.text = member.LastName
        genderTextField.accessibilityLabel = "\(member.GenderId ?? 0)"
        if let object = self.viewModel.gender.filter({ $0.Value == genderTextField.accessibilityLabel }).first {
            genderTextField.text = object.Text
        }
        dobTextField.text = member.DateOfBirth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: member.DateOfBirth ?? "")
        dateFormatter.dateFormat = "dd/MM/yy"
        let strDate = dateFormatter.string(from: date ?? Date())
        dobTextField.accessibilityLabel = strDate
        countryTextField.text = member.CountryName
        emailTextField.text = member.Email
        phoneNameTextField.text = member.Phone
        addressNameTextField.text = member.Address1
        address2NameTextField.text = member.Address2
        
        print("member.countryId",/member.CountryId)
        
        countryTextField.accessibilityLabel = member.CountryId?.toString
        if let object = self.viewModel.country.filter({ $0.Value ==  countryTextField.accessibilityLabel }).first {
            countryTextField.text = object.Text
            
        }
        else
        {
            print(self.viewModel.country.first?.Text)
            self.countryTextField.text = self.viewModel.country.first?.Text
        }
       // didTapCountryTextField(countryTextField)
        SetUpCountryTextField(countryTextField)
        stateTextField.text = member.StateName
        stateTextField.accessibilityLabel = "\(member.StateProvinceId ?? 0)"
       // didTapStateTextField(stateTextField)
        self.SetUpStateTextField(self.stateTextField)
        cityTextField.text = member.City
        cityTextField.accessibilityLabel = "\(member.CityId ?? 0)"
        pincodeTextField.text = "\(member.ZipCode ?? 0)"
        
        let dict = CountryCodeJson.filter{$0["locale"] as! String == (member.CountryNameCode ?? "IN").uppercased()}.first
        let locale = dict?["locale"] as! String
        self.flagImageView.image = UIImage(named:"CountryPicker.bundle/\(locale)")
        self.countryCodeLabel.text = member.CountryCode ?? ""
    }
}
extension MemberProfileController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.timezoneModel.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.viewModel.timezoneModel[row].DisplayName ?? ""
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.timezoneModel[row].DisplayName ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStart = row
    }
    
}
extension MemberProfileController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.dobTextField {
            datePickerTapped()
            return false
        }
        
        return true
    }
}

