
//
//  SignupPersonalDetailController.swift
//  SmileIndia
//
//  Created by user on 13/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import CoreLocation

class SignupPersonalDetailController: UIViewController {
    
    
    @IBOutlet weak var lblNav: UILabel!
    @IBOutlet weak var NPITextField: CustomTextfield!
    @IBOutlet weak var DAATextField: UITextField!
    @IBOutlet weak var timeZoneTextField: CustomTextfield!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var pincodeTextfield: UITextField!
    @IBOutlet weak var countryTextfield: CustomTextfield!
    @IBOutlet weak var stateTextfield: CustomTextfield!
    @IBOutlet weak var cityTextfield: CustomTextfield!
    @IBOutlet weak var expTextfield: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var address2Textfield: UITextField!
    @IBOutlet weak var consultationFeeTextfield: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var websiteTextfield: UITextField!
    @IBOutlet weak var tasView: UITextView!
    @IBOutlet weak var econsultFeeLabel: UITextField!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var otherCityTextField: UITextField!
    @IBOutlet weak var otherView: UIStackView!
   
    @IBOutlet weak var tdrTF: UITextField!
    
    var locationManager: CLLocationManager?
    var lat = String()
    var long = String()
    let viewmodel = SignupViewModel()
    var dict = [String: Any]()
    var customerType = String()
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            self.doctorImageView.image = $0
        }
        return imagePicker
       }()
    var touchState = 0
    let pvStart = UIPickerView()
    let citiPicker = UIPickerView()
    var selectedStart = 0
    var selectedCity = 0
    var timeZoneId = ""
    var cityID = ""
    var userstimeZone: String {
       return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ?.daylightSaving :.standard,locale: .current) ?? ""
       }
    
    var countryCodeName = "US"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

        
        hideKeyboardWhenTappedAround()
        otherView.isHidden = true
        
        countryTextfield.rightViewMode = UITextField.ViewMode.always
        countryTextfield.rightView = UIImageView(image: UIImage(named: "dropdown"))
        stateTextfield.rightViewMode = UITextField.ViewMode.always
        stateTextfield.rightView = UIImageView(image: UIImage(named: "dropdown"))
        cityTextfield.rightViewMode = UITextField.ViewMode.always
        cityTextfield.rightView = UIImageView(image: UIImage(named: "dropdown"))
     
        getCurrentLocation()
        viewmodel.getTimeZone()
            {
             self.createPicker()
             self.dismissPickerView()
             self.getAutomaticTimeZoneAndId()
           }
        viewmodel.getCountry(){
            self.countryTextfield.array = self.viewmodel.country
            self.view.activityStopAnimating()
         }
        
        
        self.tasView.delegate = self
    /*   countryCodeView.isUserInteractionEnabled = true
       let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countrycodeList))
       countryCodeView.addGestureRecognizer(tapGesture) */
 }
    func createPicker() -> Void {
           pvStart.delegate = self
           timeZoneTextField.rightViewMode = UITextField.ViewMode.always
           timeZoneTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
           timeZoneTextField.inputView = pvStart
        
           citiPicker.delegate = self
           cityTextfield.rightViewMode = UITextField.ViewMode.always
           cityTextfield.rightView = UIImageView(image: UIImage(named: "dropdown"))
           cityTextfield.inputView = citiPicker
       }
       func dismissPickerView() {
           let toolBar = UIToolbar()
           toolBar.sizeToFit()
           
           let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
           button.tintColor = .lightGray
           toolBar.setItems([button], animated: true)
           toolBar.isUserInteractionEnabled = true
           timeZoneTextField.inputAccessoryView = toolBar
           cityTextfield.inputAccessoryView = toolBar
       }
       
       @objc func action() {
           if timeZoneTextField.isEditing == true {
               timeZoneTextField.text = self.viewmodel.timezoneModel[selectedStart].DisplayName
               self.timeZoneId = self.viewmodel.timezoneModel[selectedStart].Id ?? ""
           
           }
        else if cityTextfield.isEditing == true {
            if selectedCity == 0 {
                 cityTextfield.text = "Others"
                 otherView.isHidden = false
                 otherCityTextField.isHidden = false
            }    else{
                 cityTextfield.text = self.viewmodel.cities[selectedCity].Text
                 self.cityID = self.viewmodel.cities[selectedCity].Value ?? ""
                 otherView.isHidden = true
                 otherCityTextField.isHidden = true
            }
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
                       
                       self.flagImageView.image = countryDic["countryImage"] as? UIImage
                       self.countryCodeLabel.text = "+\(countryDic["code"] as! NSNumber)"
                       self.countryCodeName = "\(countryDic["locale"] ?? "US")"
                    
                   }
        }
    @IBAction func didTapCountryTextField(_ sender: Any) {
        guard let countryId = countryTextfield.accessibilityLabel else {
                   return}
            viewmodel.getState(countryId) {
                   self.stateTextfield.array = self.viewmodel.states
                   self.stateTextfield.accessibilityLabel = "0"
                    if let object = self.viewmodel.states.filter({ $0.Value == self.stateTextfield.accessibilityLabel }).first {
                        self.stateTextfield.text = object.Text
                        self.didTapStateTextField(UIButton())
                    }
               }
    }
    @IBAction func didTapStateTextField(_ sender: Any) {
        guard let stateId = stateTextfield.accessibilityLabel else {
            return}
        
        viewmodel.getCity(stateId){
            self.citiPicker.reloadAllComponents()
            print(self.cityTextfield.array)
            if self.touchState == 1{
                self.cityTextfield.accessibilityLabel = "0"
                if let object = self.viewmodel.cities.filter({ $0.Value == self.cityTextfield.accessibilityLabel }).first {
                    self.cityTextfield.text = object.Text
                }
            }else{
                self.cityTextfield.text = "Others"
            }
            self.touchState = 0
        }
    }
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }

    @IBAction func didTapNextButton(_ sender: Any) {
        
    if isValid() {
        dict["Phone"] = phoneTextfield.text
        dict["CountryId"] = countryTextfield.accessibilityLabel
        dict["ZipCode"] = pincodeTextfield.text
        dict["TimeZoneId"] = self.timeZoneId
        dict["StateId"] = stateTextfield.accessibilityLabel
        dict["Address1"] = addressTextfield.text
        dict["Address2"] = address2Textfield.text
        dict["ConsultationFee"] = consultationFeeTextfield.text
        dict["DiscountOffered"] = discountTextField.text
        dict["EConsultationFee"] = econsultFeeLabel.text
        dict["TellAboutYourSelf"] = tasView.text
        dict["NPINo"] = NPITextField.text
        dict["DAA"] = DAATextField.text
        dict["Experience"] = expTextfield.text
        dict["Website"] = websiteTextfield.text
        dict["Latitude"] = lat
        dict["Longitude"] = long
        dict["CountryCode"] = self.countryCodeLabel.text
        dict["CountryNameCode"] = self.countryCodeName
        dict["TreatmentDiscount"] = self.tdrTF.text
        
        if selectedCity == 0 {
            dict["CityName"] = otherCityTextField.text
            dict["CityId"] = "-1"
        }
        else{
            dict["CityId"] = viewmodel.cities[selectedCity].Value ?? 0
        }
        let doctor = doctorImageView.image == UIImage.init(named: "doctor-avtar") ? nil : doctorImageView.image
         NavigationHandler.pushTo(.morninTimingsVC(dict, doctor, customerType))
       // NavigationHandler.pushTo(.morningTiming(dict, doctor, customerType))
        }
        print(dict)
    }
    
}
extension SignupPersonalDetailController{
    func isValid() -> Bool {
        
        if phoneTextfield.text?.isEmptyString() ?? false  {
            phoneTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Mobile No. Is Required."))
            return false
        }else if  countryTextfield.accessibilityLabel == "0" || countryTextfield.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Country Is Required."))
            return false
        }else if  stateTextfield.accessibilityLabel == "0" || stateTextfield.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("State Is Required."))
            return false
        }else if cityTextfield.text! == "None"{
            AlertManager.showAlert(type: .custom("City Is Required."))
            return false
        }
        
        else if addressTextfield.text?.isEmptyString() ?? false{
            addressTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Address Is Required."))
            return false
        }
        else if address2Textfield.text?.isEmptyString() ?? false{
            address2Textfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Address Line 2 Is Required."))
            return false
        }
        else if NPITextField.text?.isEmptyString() ?? false {
            NPITextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("NPI/MINC Number is Required."))
                     return false
                 }
        else if expTextfield.text?.isEmptyString() ?? false {
            expTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Experience is Required."))
                     return false
                 }
    else if !websiteTextfield.text!.isEmpty && !websiteTextfield.text!.isStringLink(){
        websiteTextfield.becomeFirstResponder()
                AlertManager.showAlert(type: .custom("Enter valid url for the website."))
                return false
        }
    else if phoneTextfield.text?.isEmptyString() ?? false || phoneTextfield.text!.count < 10 {
        phoneTextfield.becomeFirstResponder()
        AlertManager.showAlert(type: .custom("Mobile No. Is Required."))
        return false
    }else if phoneTextfield.text!.isEmpty || !phoneTextfield.text!.prefix(1).allSatisfy(("1"..."9").contains) {
        phoneTextfield.becomeFirstResponder()
        AlertManager.showAlert(type: .custom("Please Enter Valid Phone No."))
        return false
    }
    else if DAATextField.text!.count < 9 && DAATextField.text!.count > 0 {
        DAATextField.becomeFirstResponder()
        AlertManager.showAlert(type: .custom("Please Enter Valid DEA No."))
        return false
    }else if NPITextField.text!.count < 10 && DAATextField.text!.count > 0 {
        NPITextField.becomeFirstResponder()
        AlertManager.showAlert(type: .custom("Please Enter Valid NPI/MINC No."))
        return false
    }
        
        else if let exp  = Int(expTextfield.text ?? "0"), exp > 99 {
            expTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Please Enter Experience Value Less Than Or Equal To 99."))
            return false
        }
        else if pincodeTextfield.text!.isEmpty   {
            pincodeTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Zip / PO Code is required"))
            return false
        }
        else if consultationFeeTextfield.text!.isEmpty  {
            consultationFeeTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Consultation Fee is required"))
            return false
        }
        else if let ex  = Float(consultationFeeTextfield.text ?? "0"), ex < 1.00 {
            consultationFeeTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Consultation Fee should not be less than 1$"))
            return false
        }else if let ex  = Float(tdrTF.text ?? "0"), ex < 1.00 && !(self.tdrTF.text!.isEmpty){
            tdrTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Please Enter Uninsured Treatment Discount Value Greater Than Or Equal To 1."))
            return false
        }else if let ex  = Float(tdrTF.text ?? "0"), ex > 100.00 && !(self.tdrTF.text!.isEmpty){
            tdrTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Please Enter Uninsured Treatment Discount Value Less Than Or Equal To 100."))
            return false
        }
        else if discountTextField.text!.isEmpty {
            discountTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Price For Member is required"))
            return false
        }
        else if let ex  = Float(discountTextField.text ?? "0"), ex < 1.00 {
            discountTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Price for Member should not be less than 1$"))
            return false
        }
       
        
        else if let memberprice  = Int(discountTextField.text ?? "0"),memberprice > Int(consultationFeeTextfield.text ?? "0") ?? 0 {
            discountTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("Price for Member Should be Less Than Consultation fee."))
            return false
        }
       
        
        else if cityTextfield.text! == "Others"{
            if otherCityTextField.text == ""{
                AlertManager.showAlert(type: .custom("Add Your City"))
                return false
            }
           
        }

        return true
    }
    
    func isExists() -> Void {
        let queryItems = ["Phone":phoneTextfield.text!] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.isExists(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        AlertManager.showAlert(type: .custom(response.message ?? ""))
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
    
    @IBAction func didTapSelectPhoto(_ sender: Any) {
        picker.showOptions()
    }
    
}
extension SignupPersonalDetailController: CLLocationManagerDelegate{
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation:CLLocation = locations[0] as CLLocation
    manager.stopUpdatingLocation()
    
    guard let locationManager = self.locationManager else {
    return
    }
    locationManager.delegate = nil
    locationManager.stopUpdatingLocation()
    lat = "\(userLocation.coordinate.latitude)"
    long = "\(userLocation.coordinate.longitude)"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
{
    print("Error \(error)")
    }
}
extension SignupPersonalDetailController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pvStart{
        return self.viewmodel.timezoneModel.count
        }
        else {
            return self.viewmodel.cities.count + 1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        if pickerView == pvStart{
            pickerLabel?.text = self.viewmodel.timezoneModel[row].DisplayName ?? ""
        }
        else {
            if row == 0 {
                pickerLabel?.text = "Others"
            }
            else{
            pickerLabel?.text = self.viewmodel.cities[row - 1].Text ?? ""
             }
        }
         return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pvStart{
            return self.viewmodel.timezoneModel[row].DisplayName ?? ""
        }
        else {
            if row == 0 {
                return "Others"
            }
            else{
                return self.viewmodel.cities[row - 1].Text ?? ""
             }
            
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          
        
        if pickerView == pvStart{
            selectedStart = row
        }
        else {
            if row == 0 {
                selectedCity = 0
                
            }
            else{
                selectedCity = row - 1
            }
        
    }

}
}

extension SignupPersonalDetailController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
       // charactersCountLabel.text = "\(140-numberOfChars)"
        return numberOfChars < 200    // 10 Limit Value
    }
}


